Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D84F9427554
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 03:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244003AbhJIBMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 21:12:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:43868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232018AbhJIBMX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 21:12:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AA0660F93;
        Sat,  9 Oct 2021 01:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633741827;
        bh=KiWt6JP86c0eX+b0m3aRh8EePWU2A/eV5i2+T+kpZ/c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kQmr/ZYsMUzOSDSWzgQSBmZStqWyrhn2R4uBPUDo5GgVrw8UlK1p83Q7GVI2ndjSk
         pKxQ9MLNwaYAFzkVnLCZF8NqpQBy5/ViMW8R7NPOhjlFT5FpGVgvca7PjZDsaygY2w
         5Lj0FZDFOM9lnv1lpVKvIVE8donbJZaFvPEjqvc+NHvA5gQUJ/onzkSs7jpofjCihT
         XPIWkarmLX/5BWyXME6rus0BD8woQo30ZiUE+LxOfqtJnMBq4YTtjb1m4E77L1qs3l
         y4nQb8DA5mClRmkzcc046MTm5xdTLcTne4AI91OK62S+9gwsUlJFNei+JuMIF44Le1
         BjOi+MBfsTz3g==
Date:   Fri, 8 Oct 2021 18:10:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, ast@kernel.org,
        daniel@iogearbox.net, shayagr@amazon.com, john.fastabend@gmail.com,
        dsahern@kernel.org, brouer@redhat.com, echaudro@redhat.com,
        jasowang@redhat.com, alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: Re: [PATCH v15 bpf-next 17/18] net: xdp: introduce bpf_xdp_pointer
 utility routine
Message-ID: <20211008181026.0b94149a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <911989270cd187c98a65edabc709eb1f49af3e51.1633697183.git.lorenzo@kernel.org>
References: <cover.1633697183.git.lorenzo@kernel.org>
        <911989270cd187c98a65edabc709eb1f49af3e51.1633697183.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  8 Oct 2021 14:49:55 +0200 Lorenzo Bianconi wrote:
> +BPF_CALL_4(bpf_xdp_load_bytes, struct xdp_buff *, xdp, u32, offset,
> +	   void *, buf, u32, len)
> +{
> +	void *ptr;
> +
> +	if (!buf)
> +		return -EINVAL;

Can we make the verifier ensure it's not NULL?

> +	ptr = bpf_xdp_pointer(xdp, offset, len, buf);
> +	if (ptr != buf)
> +		memcpy(buf, ptr, len);

Don't we need to return an error in case offset + length > frame size?

> +	return 0;
> +}
