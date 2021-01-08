Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3076B2EF5D0
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 17:33:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728365AbhAHQdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 11:33:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:40052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727132AbhAHQdL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 11:33:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35EFE238E8;
        Fri,  8 Jan 2021 16:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610123550;
        bh=a7clnkcGT69gTaK4mqWzBpTadu9+VVXSl8WJvUAXUko=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GCJGW6dSt3wy+e4Il7aZzSpbkkTvS+jqwcDKwEM7qHkZdekGOZkgdykGqubZvQ72a
         kWucJcoQQajb1n6y6rZpCZS7Tg8061lFpx9Ha48oQCigfJkjINco9y9DeVzISe1LfH
         lQ//EZGMOJtXcFRahwxJMAMQ1J6j90Xrv/8UZiHFzN7LjgGMYq2NXsqWqAuALrA8/X
         MeMGERCrswuaORrRBVy+3t1H6ibmHMQe5LQ+T59poekmy6MYQ40LG2gtsWCSYN29DE
         eOuFSI5ZHSVMxhvblY8MMnvG3D0SPTqvtHRVh5f4NWPGjxuUXrq5owmwvxmdddS3my
         VW9Xs1Bno9Fqw==
Date:   Fri, 8 Jan 2021 08:32:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>, netdev@vger.kernel.org,
        linux-can@vger.kernel.org, Dan Murphy <dmurphy@ti.com>,
        kernel@pengutronix.de, Sean Nyekjaer <sean@geanix.com>,
        davem@davemloft.net
Subject: Re: [net-next 15/19] can: tcan4x5x: rework SPI access
Message-ID: <20210108083229.6f42479b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <8185f3e1-d0b1-0ea4-ac45-f2ea0b63ced9@pengutronix.de>
References: <20210107094900.173046-1-mkl@pengutronix.de>
        <20210107094900.173046-16-mkl@pengutronix.de>
        <20210107110035.42a6bb46@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210107110656.7e49772b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <c98003bf-e62a-ab6a-a526-1f3ed0bb1ab7@pengutronix.de>
        <20210107143851.51675f8d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <8185f3e1-d0b1-0ea4-ac45-f2ea0b63ced9@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 8 Jan 2021 11:07:26 +0100 Ahmad Fatoum wrote:
> >>> +struct __packed tcan4x5x_map_buf { 
> >>> +	struct tcan4x5x_buf_cmd cmd; 
> >>> +	u8 data[256 * sizeof(u32)]; 
> >>> +} ____cacheline_aligned;     
> >>
> >> Due to the packing of the struct tcan4x5x_buf_cmd it should have a length of 4
> >> bytes. Without __packed, will the "u8 data" come directly after the cmd?  
> > 
> > Yup, u8 with no alignment attribute will follow the previous
> > field with no holes.  
> 
> __packed has a documentation benefit though. It documents that the author
> considers the current layout to be the only correct one. (and thus extra
> care should be taken when modifying it).

____cacheline_aligned adds a big architecture dependent padding at the
end of this struct, so the size of this structure is architecture
dependent. Besides using packed forced the compiler to use byte by byte
loads on architectures without unaligned access, so __packed is not
free.
