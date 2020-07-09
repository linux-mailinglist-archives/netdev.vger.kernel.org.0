Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3F021A969
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 22:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbgGIU4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 16:56:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:54434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726396AbgGIU4H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 16:56:07 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA7F720672;
        Thu,  9 Jul 2020 20:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594328167;
        bh=AXlmveoN1k4XAKt7/NTHnxv4Aeg22Dxmzrq9KiDeHwU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RZPWtiBwZIQz8k79nuUQUoAaNBWGUnw3uWSJ1Aam5iooMGDKxAQPb0RZEOYifI5Ey
         +V54cMv7QCBmXIfi2+KcB2TN7BCrZ2M5MOMt37FwbFoPr/73+DuYhuAnVkPzxjunYA
         VFf04++7DBhSuyrKCkCavy8GAVFcgG//8/UkAJKw=
Date:   Thu, 9 Jul 2020 13:56:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Edwin Peer <edwin.peer@broadcom.com>,
        emil.s.tantilov@intel.com, alexander.h.duyck@linux.intel.com,
        jeffrey.t.kirsher@intel.com, Tariq Toukan <tariqt@mellanox.com>,
        mkubecek@suse.cz
Subject: Re: [PATCH net-next v2 09/10] bnxt: convert to new udp_tunnel_nic
 infra
Message-ID: <20200709135605.6ad96b88@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CACKFLikN6utQT2eXKtnhZFMYxt8Tem-An=6cxX6nXgPiO+k5UQ@mail.gmail.com>
References: <20200709011814.4003186-1-kuba@kernel.org>
        <20200709011814.4003186-10-kuba@kernel.org>
        <CACKFLikN6utQT2eXKtnhZFMYxt8Tem-An=6cxX6nXgPiO+k5UQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Jul 2020 22:27:13 -0700 Michael Chan wrote:
> On Wed, Jul 8, 2020 at 6:18 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > Convert to new infra, taking advantage of sleeping in callbacks.
> >
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > ---
> >  drivers/net/ethernet/broadcom/bnxt/bnxt.c | 133 ++++++----------------
> >  drivers/net/ethernet/broadcom/bnxt/bnxt.h |   6 -
> >  2 files changed, 34 insertions(+), 105 deletions(-)
> >  
> 
> > diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
> > index 78e2fd63ac3d..352a56a18916 100644
> > --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
> > +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
> > @@ -1752,10 +1752,8 @@ struct bnxt {
> >  #define BNXT_FW_MAJ(bp)                ((bp)->fw_ver_code >> 48)
> >
> >         __be16                  vxlan_port;  
> 
> We can also do away with vxlan_port and nge_port, now that we no
> longer need to pass the port from NDO to workqueue.  We just need to
> initialize the 2 firmware tunnel IDs to INVALID_HW_RING_ID before use
> and after free.  But it is ok the way you have it too.

Seems like I need to send a v3 anyway - the only reason I kept them is
to know if bnxt_hwrm_free_tunnel_ports() has to issue its commands or
not.

Are you suggesting I just add a flag that'd say "tunnel in use" instead
of holding onto the ports?  Or free unconditionally?
