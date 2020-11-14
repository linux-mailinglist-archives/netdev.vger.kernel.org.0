Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05F362B3039
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 20:33:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbgKNTcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 14:32:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:54938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726121AbgKNTcG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Nov 2020 14:32:06 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34F8F22265;
        Sat, 14 Nov 2020 19:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605382326;
        bh=Lj0hs9+tPoVhDVreno0ECbxXnMotAEd2o1z46CMMFb0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Fhl/Kv1itdZqBjRSp81QtSi5wzd2O44HKK4G3G4GexCVgUn3AJSWX1lPNeSqQsauO
         QpjZuWutun5kx1Xb6s4umMZjDF07eITuEUuxM9IEehru58807cRau93cHXgQbgwsif
         dxVCtsY6EOUBkled2h+pScU0V0jVLrdC4ihOepL8=
Date:   Sat, 14 Nov 2020 11:32:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, andrew@lunn.ch, vivien.didelot@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net] net: dsa: mv88e6xxx: Avoid VTU corruption on
 6097
Message-ID: <20201114113205.19c02fa9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201112114335.27371-1-tobias@waldekranz.com>
References: <20201112114335.27371-1-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Nov 2020 12:43:35 +0100 Tobias Waldekranz wrote:
> As soon as you add the second port to a VLAN, all other port
> membership configuration is overwritten with zeroes. The HW interprets
> this as all ports being "unmodified members" of the VLAN.
> 
> In the simple case when all ports belong to the same VLAN, switching
> will still work. But using multiple VLANs or trying to set multiple
> ports as tagged members will not work.
> 
> On the 6352, doing a VTU GetNext op, followed by an STU GetNext op
> will leave you with both the member- and state- data in the VTU/STU
> data registers. But on the 6097 (which uses the same implementation),
> the STU GetNext will override the information gathered from the VTU
> GetNext.
> 
> Separate the two stages, parsing the result of the VTU GetNext before
> doing the STU GetNext.
> 
> We opt to update the existing implementation for all applicable chips,
> as opposed to creating a separate callback for 6097, because although
> the previous implementation did work for (at least) 6352, the
> datasheet does not mention the masking behavior.
> 
> Fixes: ef6fcea37f01 ("net: dsa: mv88e6xxx: get STU entry on VTU GetNext")
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>

Applied, thanks!
