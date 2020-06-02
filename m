Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30D191EB612
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 09:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbgFBHAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 03:00:23 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49831 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725900AbgFBHAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 03:00:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591081221;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lfNo/OA7vYBOJCjR3+lm4KXoGEIqmcVh2aJFMlUw6u8=;
        b=fddBoHRYDuX0rXB8pCMT+ni0vzDGPl++o2g1bpfBDY9U309lccCieS5/O4Vxqx4jBsYqwY
        T8TIAHQShgJwZSXSlP7ZxgrxVdczh8sTzzMnTV1Mt+iCPCbR/yhuha+v3HnbkulDne6+eD
        3etCKH1V5HKkRAPhWF1149oAR4VPbbE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-wiWh0Yy4Oj2X5XS3BY0q2Q-1; Tue, 02 Jun 2020 03:00:16 -0400
X-MC-Unique: wiWh0Yy4Oj2X5XS3BY0q2Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 04A13BFC0;
        Tue,  2 Jun 2020 07:00:15 +0000 (UTC)
Received: from carbon (unknown [10.40.208.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1C17811A9DF;
        Tue,  2 Jun 2020 07:00:06 +0000 (UTC)
Date:   Tue, 2 Jun 2020 09:00:05 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>, brouer@redhat.com,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: Re: [PATCH bpf-next RFC 2/3] bpf: devmap dynamic map-value storage
 area based on BTF
Message-ID: <20200602090005.5a6eb50c@carbon>
In-Reply-To: <20200601213012.vgt7oqplfbzeddzm@ast-mbp.dhcp.thefacebook.com>
References: <159076794319.1387573.8722376887638960093.stgit@firesoul>
        <159076798566.1387573.8417040652693679408.stgit@firesoul>
        <20200601213012.vgt7oqplfbzeddzm@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 1 Jun 2020 14:30:12 -0700
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> On Fri, May 29, 2020 at 05:59:45PM +0200, Jesper Dangaard Brouer wrote:
> > +
> > +/* Expected BTF layout that match struct bpf_devmap_val */
> > +static const struct expect layout[] = {
> > +	{BTF_KIND_INT,		true,	 0,	 4,	"ifindex"},
> > +	{BTF_KIND_UNION,	false,	32,	 4,	"bpf_prog"},
> > +	{BTF_KIND_STRUCT,	false,	-1,	-1,	"storage"}
> > +};
> > +
> > +static int dev_map_check_btf(const struct bpf_map *map,
> > +			     const struct btf *btf,
> > +			     const struct btf_type *key_type,
> > +			     const struct btf_type *value_type)
> > +{
> > +	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
> > +	u32 found_members_cnt = 0;
> > +	u32 int_data;
> > +	int off;
> > +	u32 i;
> > +
> > +	/* Validate KEY type and size */
> > +	if (BTF_INFO_KIND(key_type->info) != BTF_KIND_INT)
> > +		return -EOPNOTSUPP;
> > +
> > +	int_data = *(u32 *)(key_type + 1);
> > +	if (BTF_INT_BITS(int_data) != 32 || BTF_INT_OFFSET(int_data) != 0)
> > +		return -EOPNOTSUPP;
> > +
> > +	/* Validate VALUE have layout that match/map-to struct bpf_devmap_val
> > +	 * - With a flexible size of member 'storage'.
> > +	 */
> > +
> > +	if (BTF_INFO_KIND(value_type->info) != BTF_KIND_STRUCT)
> > +		return -EOPNOTSUPP;
> > +
> > +	/* Struct/union members in BTF must not exceed (max) expected members */
> > +	if (btf_type_vlen(value_type) > ARRAY_SIZE(layout))
> > +			return -E2BIG;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(layout); i++) {
> > +		off = btf_find_expect_layout_offset(btf, value_type, &layout[i]);
> > +
> > +		if (off < 0 && layout[i].mandatory)
> > +			return -EUCLEAN;
> > +
> > +		if (off >= 0)
> > +			found_members_cnt++;
> > +
> > +		/* Transfer layout config to map */
> > +		switch (i) {
> > +		case 0:
> > +			dtab->cfg.btf_offset.ifindex = off;
> > +			break;
> > +		case 1:
> > +			dtab->cfg.btf_offset.bpf_prog = off;
> > +			break;
> > +		default:
> > +			break;
> > +		}
> > +	}
> > +
> > +	/* Detect if BTF/vlen have members that were not found */
> > +	if (btf_type_vlen(value_type) > found_members_cnt)
> > +		return -E2BIG;
> > +
> > +	return 0;
> > +}  
> 
> This layout validation looks really weird to me.
> That layout[] array sort of complements BTF to describe the data,
> but double describe of the layout feels like hack.

This is the kind of feedback I'm looking for.  I want to make the
map-value more dynamic.  It seems so old school to keep extending the
map-value with a size and fixed binary layout, when we have BTF
available.  I'm open to input on how to better verify/parse/desc the
expected BTF layout for kernel-code side.

The patch demonstrates that this is possible, I'm open for changes.
E.g. devmap is now extended with a bpf_prog, but most end-users will
not be using this feature. Today they can use value_size=4 to avoid
using this field. When we extend map-value again, then end-users are
force into providing 'bpf_prog.fd' if they want to use the newer
options.  In this patch end-users don't need to provide 'bpf_prog' if
they don't use it. Via BTF we can see this struct member can be skipped.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

