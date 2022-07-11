Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70DD657011C
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 13:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbiGKLtC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 07:49:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiGKLtB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 07:49:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 93B52B871
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 04:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657540138;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZVC5+vLlHSkEVu0gdtlphAcJ8c2U3360hXV9M7aAdQE=;
        b=DL+6f1UCi9M0iCruzc68IFkltscbrnctAA2QbUsQSCW6CNRT7kcWtuIh8TcDg46J51/iUN
        yECp9oGhWIcu2POIEpcsP7ZdrSza7ugAlLSAUBiJKnHQgBtluZywQGqWNficcSoxg/5aCs
        gdmAy4tZ1ADRV5kA3RyfY2CnDw6xVLE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-619-wHLVoU5ZM82MtN1MmMIylw-1; Mon, 11 Jul 2022 07:48:55 -0400
X-MC-Unique: wHLVoU5ZM82MtN1MmMIylw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C8ABE85A581;
        Mon, 11 Jul 2022 11:48:54 +0000 (UTC)
Received: from samus.usersys.redhat.com (unknown [10.43.17.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7DAA61121314;
        Mon, 11 Jul 2022 11:48:53 +0000 (UTC)
Date:   Mon, 11 Jul 2022 13:48:51 +0200
From:   Artem Savkov <asavkov@redhat.com>
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFC PATCH bpf-next 2/4] bpf: add BPF_F_DESTRUCTIVE flag for
 BPF_PROG_LOAD
Message-ID: <YswOIzI7urHs4XBi@samus.usersys.redhat.com>
Mail-Followup-To: Jiri Olsa <olsajiri@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrea Arcangeli <aarcange@redhat.com>
References: <20220711083220.2175036-1-asavkov@redhat.com>
 <20220711083220.2175036-3-asavkov@redhat.com>
 <YswB3CebEK0ltAwt@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YswB3CebEK0ltAwt@krava>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 11, 2022 at 12:56:28PM +0200, Jiri Olsa wrote:
> On Mon, Jul 11, 2022 at 10:32:18AM +0200, Artem Savkov wrote:
> > Add a BPF_F_DESTRUCTIVE will be required to be supplied to
> > BPF_PROG_LOAD for programs to utilize destructive helpers such as
> > bpf_panic().
> 
> I'd think that having kernel.destructive_bpf_enabled sysctl knob enabled
> would be enough to enable that helper from any program, not sure having
> extra load flag adds more security

I agree it doesn't add more security. The idea was to have a way for a
developer to explicitly state he understand this will be dangerous. This
flag can also translate well into something like a --destructive option
for bpftrace without needing to keep a list of destructive helpers on
their side.

-- 
 Artem

