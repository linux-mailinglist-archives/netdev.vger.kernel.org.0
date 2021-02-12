Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33CFF31A4C4
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 19:52:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbhBLSwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 13:52:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:56748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229558AbhBLSwC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 13:52:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2869664D9C;
        Fri, 12 Feb 2021 18:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613155881;
        bh=jj13ApDkX91B6OtLGp/ZXzGi1So693eCu2KZa+gCTTU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=exjvgJnz7ckjGF18O//q2Lv4XgVM+uLSCn6MmbdWUhoIZ/80+JdENZEKUK4h/BAzX
         jzDrhmjEQuFrr8EHMSblj77qH8WXW086usQnHvSzIx2tarKGUKV468IDVhseOtXeV6
         DqZSoeQDCijx/R2qWG5C4Hr02jW0As18tZz4gH6rBg8SbWqT9UTXLXTCEPW3lJPY/9
         ET28nCNKto1/gxUQVuZ2k3JPo+oNTJRh4w8haVlDqN8c27+IAWhqJZ2T7udH+Yu4bd
         /6yGk3JP+ag62LOEltpne6UPwqrw6g+A/InMRAI1LumvPbgFZfEAZQXUISR6l0Y6UK
         qDHi8+wyZMzeA==
Date:   Fri, 12 Feb 2021 10:51:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@ieee.org>
Cc:     Sharath Chandra Vurukala <sharathv@codeaurora.org>,
        davem@davemloft.net, elder@kernel.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] net:ethernet:rmnet:Support for downlink MAPv5 csum
 offload
Message-ID: <20210212105120.01b04172@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1c4e21bf-5903-bc45-6d6e-64b68e494542@ieee.org>
References: <1613079324-20166-1-git-send-email-sharathv@codeaurora.org>
        <1613079324-20166-3-git-send-email-sharathv@codeaurora.org>
        <20210211180459.500654b4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <1c4e21bf-5903-bc45-6d6e-64b68e494542@ieee.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 12 Feb 2021 08:01:15 -0600 Alex Elder wrote:
> On 2/11/21 8:04 PM, Jakub Kicinski wrote:
> > On Fri, 12 Feb 2021 03:05:23 +0530 Sharath Chandra Vurukala wrote:  
> >> +/* MAP CSUM headers */
> >> +struct rmnet_map_v5_csum_header {
> >> +	u8  next_hdr:1;
> >> +	u8  header_type:7;
> >> +	u8  hw_reserved:5;
> >> +	u8  priority:1;
> >> +	u8  hw_reserved_bit:1;
> >> +	u8  csum_valid_required:1;
> >> +	__be16 reserved;
> >> +} __aligned(1);  
> > 
> > Will this work on big endian?  
> 
> Sort of related to this point...
> 
> I'm sure the response to this will be to add two versions
> of the definition, surrounded __LITTLE_ENDIAN_BITFIELD
> and __BIG_ENDIAN_BITFIELD tests.
> 
> I really find this non-intuitive, and every time I
> look at it I have to think about it a bit to figure
> out where the bits actually lie in the word.
> 
> I know this pattern is used elsewhere in the networking
> code, but that doesn't make it any easier for me to
> understand...
> 
> Can we used mask, defined in host byte order, to
> specify the positions of these fields?
> 
> I proposed a change at one time that did this and
> this *_ENDIAN_BITFIELD thing was used instead.
> 
> I will gladly implement this change (completely
> separate from what's being done here), but thought
> it might be best to see what people think about it
> before doing that work.

Most definitely agree, please convert.
