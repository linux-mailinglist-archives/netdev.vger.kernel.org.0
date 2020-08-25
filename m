Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE3E0251D6C
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 18:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbgHYQqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 12:46:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:39036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726356AbgHYQqi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Aug 2020 12:46:38 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91F3F20782;
        Tue, 25 Aug 2020 16:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598373997;
        bh=xPf4qnr4U10YGaUJZ1G5IsRUUwhYWrqDszxcH16X62Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nDfrk6jLD7xqv6LU0haWgF1GbNXkCrNlAlI3fge5N9f63UH4+I3J7rWCh6qqRHwYZ
         n/sL7ByRLaoAT/WXr42x9MaHCRzHDQP6SN5sBngmmxJo5B5MZVdE5LFFkVgMTDjADz
         fQX9ZN7+wFC4Ist2/3adTKSeVduTbSyIHabUF4fc=
Date:   Tue, 25 Aug 2020 09:46:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Awogbemila <awogbemila@google.com>,
        Yangchun Fu <yangchun@google.com>
Cc:     netdev@vger.kernel.org, Kuo Zhao <kuozhao@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCH net-next 05/18] gve: Add Gvnic stats AQ command and
 ethtool show/set-priv-flags.
Message-ID: <20200825094635.715db5c0@kicinski-fedora-PC1C0HJN>
In-Reply-To: <CAL9ddJcDYcn+p33nKicmp7yHm6PnZ9iXnghO4AYHNmtCFCe2eQ@mail.gmail.com>
References: <20200818194417.2003932-1-awogbemila@google.com>
        <20200818194417.2003932-6-awogbemila@google.com>
        <20200818201350.58024c28@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAL9ddJcDYcn+p33nKicmp7yHm6PnZ9iXnghO4AYHNmtCFCe2eQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Aug 2020 08:46:12 -0700 David Awogbemila wrote:
> > > +     // stats from NIC
> > > +     RX_QUEUE_DROP_CNT               = 65,
> > > +     RX_NO_BUFFERS_POSTED            = 66,
> > > +     RX_DROPS_PACKET_OVER_MRU        = 67,
> > > +     RX_DROPS_INVALID_CHECKSUM       = 68,  
> >
> > Most of these look like a perfect match for members of struct
> > rtnl_link_stats64. Please use the standard stats to report the errors,
> > wherever possible.  
> These stats are based on the NIC stats format which don't exactly
> match rtnl_link_stats64.
> I'll add some clarification in the description and within the comments.

You must report standard stats. Don't be lazy and just dump everything
in ethtool -S and expect the user to figure out the meaning of your
strings.

> > > +static int gve_set_priv_flags(struct net_device *netdev, u32 flags)
> > > +{
> > > +     struct gve_priv *priv = netdev_priv(netdev);
> > > +     u64 ori_flags, new_flags;
> > > +     u32 i;
> > > +
> > > +     ori_flags = READ_ONCE(priv->ethtool_flags);
> > > +     new_flags = ori_flags;
> > > +
> > > +     for (i = 0; i < GVE_PRIV_FLAGS_STR_LEN; i++) {
> > > +             if (flags & BIT(i))
> > > +                     new_flags |= BIT(i);
> > > +             else
> > > +                     new_flags &= ~(BIT(i));
> > > +             priv->ethtool_flags = new_flags;
> > > +             /* set report-stats */
> > > +             if (strcmp(gve_gstrings_priv_flags[i], "report-stats") == 0) {
> > > +                     /* update the stats when user turns report-stats on */
> > > +                     if (flags & BIT(i))
> > > +                             gve_handle_report_stats(priv);
> > > +                     /* zero off gve stats when report-stats turned off */
> > > +                     if (!(flags & BIT(i)) && (ori_flags & BIT(i))) {
> > > +                             int tx_stats_num = GVE_TX_STATS_REPORT_NUM *
> > > +                                     priv->tx_cfg.num_queues;
> > > +                             int rx_stats_num = GVE_RX_STATS_REPORT_NUM *
> > > +                                     priv->rx_cfg.num_queues;
> > > +                             memset(priv->stats_report->stats, 0,
> > > +                                    (tx_stats_num + rx_stats_num) *
> > > +                                    sizeof(struct stats));  
> >
> > I don't quite get why you need the knob to disable some statistics.
> > Please remove or explain this in the cover letter. Looks unnecessary.  
> We use this to give the guest the option of disabling stats reporting
> through ethtool set-priv-flags. I'll update the cover letter.

I asked you why you reply a week later with "I want to give user the
option. I'll update the cover letter." :/ That's quite painful for the
reviewer. Please just provide the justification.

> > > @@ -880,6 +953,10 @@ static void gve_handle_status(struct gve_priv *priv, u32 status)
> > >               dev_info(&priv->pdev->dev, "Device requested reset.\n");
> > >               gve_set_do_reset(priv);
> > >       }
> > > +     if (GVE_DEVICE_STATUS_REPORT_STATS_MASK & status) {
> > > +             dev_info(&priv->pdev->dev, "Device report stats on.\n");  
> >
> > How often is this printed?  
> Stats reporting is disabled by default. But when enabled, this would
> only get printed whenever the virtual NIC detects
> an issue and triggers a report-stats request.

What kind of issue? Something serious? Packet drops?
