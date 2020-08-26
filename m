Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB552524E8
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 03:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbgHZBK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 21:10:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:44860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726581AbgHZBK2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Aug 2020 21:10:28 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B77D020707;
        Wed, 26 Aug 2020 00:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598403188;
        bh=cXsYp21tBFgcGMTGarZLRZbr0stMIQOATER2aneNUAQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SXFNNebquGNYcVZx4fjRy2hrEWmijg4KFbwkfw3CsoXiTHvkXK9O1az+neQRgOTHi
         LH8nByCN8VHmirtsHDVoK8XOpnshA8X2BGynFp3mFfpRPx6UkQPhTvw8fw7E78DANP
         CSNkEFR3208/J0IRMZekSYGzYs1g1heaxV1YN+dU=
Date:   Tue, 25 Aug 2020 17:53:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Awogbemila <awogbemila@google.com>
Cc:     Yangchun Fu <yangchun@google.com>, netdev@vger.kernel.org,
        Kuo Zhao <kuozhao@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCH net-next 05/18] gve: Add Gvnic stats AQ command and
 ethtool show/set-priv-flags.
Message-ID: <20200825175306.377be2f4@kicinski-fedora-PC1C0HJN>
In-Reply-To: <CAL9ddJfOWzO1v2FJAtb+qVAazR9Tb3CV8kH8V0_xA-GPgoAKXQ@mail.gmail.com>
References: <20200818194417.2003932-1-awogbemila@google.com>
        <20200818194417.2003932-6-awogbemila@google.com>
        <20200818201350.58024c28@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAL9ddJcDYcn+p33nKicmp7yHm6PnZ9iXnghO4AYHNmtCFCe2eQ@mail.gmail.com>
        <20200825094635.715db5c0@kicinski-fedora-PC1C0HJN>
        <CAL9ddJfOWzO1v2FJAtb+qVAazR9Tb3CV8kH8V0_xA-GPgoAKXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Aug 2020 17:06:27 -0700 David Awogbemila wrote:
> On Tue, Aug 25, 2020 at 9:46 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Tue, 25 Aug 2020 08:46:12 -0700 David Awogbemila wrote:  
> > > > > +     // stats from NIC
> > > > > +     RX_QUEUE_DROP_CNT               = 65,
> > > > > +     RX_NO_BUFFERS_POSTED            = 66,
> > > > > +     RX_DROPS_PACKET_OVER_MRU        = 67,
> > > > > +     RX_DROPS_INVALID_CHECKSUM       = 68,  
> > > >
> > > > Most of these look like a perfect match for members of struct
> > > > rtnl_link_stats64. Please use the standard stats to report the errors,
> > > > wherever possible.  
> > > These stats are based on the NIC stats format which don't exactly
> > > match rtnl_link_stats64.
> > > I'll add some clarification in the description and within the comments.  
> >
> > You must report standard stats. Don't be lazy and just dump everything
> > in ethtool -S and expect the user to figure out the meaning of your
> > strings.  
> Apologies for responding a week later, I'll try to respond more quickly.

Thanks!

> I could use some help figuring out the use of rtnl_link_stats64 here.
> These 4 stats are per-queue stats written by the NIC. It looks like
> rtnl_link_stats64 is meant to sum stats for the entire device? Is the
> requirement here simply to use the member names in rtnl_link_stats64
> when reporting stats via ethtool? Thanks.

If these are per queue you can report them per queue in ethtool (name
is up to you), but you must report the sum over all queues in
rtnl_link_stats64.

FWIW the mapping I'd suggest is probably:

RX_QUEUE_DROP_CNT         -> rx_dropped
RX_NO_BUFFERS_POSTED      -> rx_missed_errors
RX_DROPS_PACKET_OVER_MRU  -> rx_length_errors
RX_DROPS_INVALID_CHECKSUM -> rx_crc_errors

The no-buffers-posted stat is unfortunately slightly disputable between
rx_missed_errors and rx_fifo_errors (even rx_over_errors). I'd go for missed.

> > > > > +static int gve_set_priv_flags(struct net_device *netdev, u32 flags)
> > > > > +{
> > > > > +     struct gve_priv *priv = netdev_priv(netdev);
> > > > > +     u64 ori_flags, new_flags;
> > > > > +     u32 i;
> > > > > +
> > > > > +     ori_flags = READ_ONCE(priv->ethtool_flags);
> > > > > +     new_flags = ori_flags;
> > > > > +
> > > > > +     for (i = 0; i < GVE_PRIV_FLAGS_STR_LEN; i++) {
> > > > > +             if (flags & BIT(i))
> > > > > +                     new_flags |= BIT(i);
> > > > > +             else
> > > > > +                     new_flags &= ~(BIT(i));
> > > > > +             priv->ethtool_flags = new_flags;
> > > > > +             /* set report-stats */
> > > > > +             if (strcmp(gve_gstrings_priv_flags[i], "report-stats") == 0) {
> > > > > +                     /* update the stats when user turns report-stats on */
> > > > > +                     if (flags & BIT(i))
> > > > > +                             gve_handle_report_stats(priv);
> > > > > +                     /* zero off gve stats when report-stats turned off */
> > > > > +                     if (!(flags & BIT(i)) && (ori_flags & BIT(i))) {
> > > > > +                             int tx_stats_num = GVE_TX_STATS_REPORT_NUM *
> > > > > +                                     priv->tx_cfg.num_queues;
> > > > > +                             int rx_stats_num = GVE_RX_STATS_REPORT_NUM *
> > > > > +                                     priv->rx_cfg.num_queues;
> > > > > +                             memset(priv->stats_report->stats, 0,
> > > > > +                                    (tx_stats_num + rx_stats_num) *
> > > > > +                                    sizeof(struct stats));  
> > > >
> > > > I don't quite get why you need the knob to disable some statistics.
> > > > Please remove or explain this in the cover letter. Looks unnecessary.  
> > > We use this to give the guest the option of disabling stats reporting
> > > through ethtool set-priv-flags. I'll update the cover letter.  
> >
> > I asked you why you reply a week later with "I want to give user the
> > option. I'll update the cover letter." :/ That's quite painful for the
> > reviewer. Please just provide the justification.  
> I apologize for the pain; it certainly wasn't intended :) .
> Just to clarify, stats will always be available to the user via ethtool.
> This is only giving users the option of disabling the reporting of
> stats from the driver to the virtual NIC should the user decide they
> do not want to share driver stats with Google as a matter of privacy.

Okay, so this is for the to-hypervisor direction. Hopefully the patch
split will make this clearer.

> > > > > @@ -880,6 +953,10 @@ static void gve_handle_status(struct gve_priv *priv, u32 status)
> > > > >               dev_info(&priv->pdev->dev, "Device requested reset.\n");
> > > > >               gve_set_do_reset(priv);
> > > > >       }
> > > > > +     if (GVE_DEVICE_STATUS_REPORT_STATS_MASK & status) {
> > > > > +             dev_info(&priv->pdev->dev, "Device report stats on.\n");  
> > > >
> > > > How often is this printed?  
> > > Stats reporting is disabled by default. But when enabled, this would
> > > only get printed whenever the virtual NIC detects
> > > an issue and triggers a report-stats request.  
> >
> > What kind of issue? Something serious? Packet drops?  
> Sorry, to correct myself, this would get printed only at the moments
> when the device switches report-stats on, not on every stats report.
> After that, it would not get printed until it is switched off and then
> on again, so rarely.
> It would get switched on if there is a networking issue such as packet
> drops and help us investigate a stuck queue for example.

Reporting of the stats is a one-shot:

+	if (gve_get_do_report_stats(priv)) {
+		gve_handle_report_stats(priv);
+		gve_clear_do_report_stats(priv);
+	}

So the hypervisor implements some rate limiting on the requests?

In general, I don't think users will want these messages to keep
popping up. A ethtool -S statistic for the number of times reporting
happened should be sufficient. Or if you really want them - have a
verbose version of the priv flag, maybe?
