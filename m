Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48F71426860
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 13:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240121AbhJHLCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 07:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239951AbhJHLCW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 07:02:22 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73414C061570
        for <netdev@vger.kernel.org>; Fri,  8 Oct 2021 04:00:27 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1mYnbl-0003cn-Hz; Fri, 08 Oct 2021 13:00:09 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1mYnbj-0002EF-Ku; Fri, 08 Oct 2021 13:00:07 +0200
Date:   Fri, 8 Oct 2021 13:00:07 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     Robin van der Gracht <robin@protonic.nl>,
        Oleksij Rempel <linux@rempel-privat.de>, kernel@pengutronix.de,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Jayat <maxime.jayat@mobile-devices.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] can: j1939: j1939_xtp_rx_dat_one(): cancel session
 if receive TP.DT with error length
Message-ID: <20211008110007.GE29653@pengutronix.de>
References: <1632972800-45091-1-git-send-email-zhangchangzhong@huawei.com>
 <20210930074206.GB7502@x1.vandijck-laurijssen.be>
 <1cab07f2-593a-1d1c-3a29-43ee9df4b29e@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1cab07f2-593a-1d1c-3a29-43ee9df4b29e@huawei.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:47:01 up 232 days, 14:10, 145 users,  load average: 0.04, 0.14,
 0.16
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 08, 2021 at 05:22:12PM +0800, Zhang Changzhong wrote:
> Hi Kurt,
> Sorry for the late reply.
> 
> On 2021/9/30 15:42, Kurt Van Dijck wrote:
> > On Thu, 30 Sep 2021 11:33:20 +0800, Zhang Changzhong wrote:
> >> According to SAE-J1939-21, the data length of TP.DT must be 8 bytes, so
> >> cancel session when receive unexpected TP.DT message.
> > 
> > SAE-j1939-21 indeed says that all TP.DT must be 8 bytes.
> > However, the last TP.DT may contain up to 6 stuff bytes, which have no meaning.
> > If I remember well, they are even not 'reserved'.
> 
> Agree, these bytes are meaningless for last TP.DT.
> 
> >
> >>
> >> Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
> >> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> >> ---
> >>  net/can/j1939/transport.c | 7 +++++--
> >>  1 file changed, 5 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
> >> index bb5c4b8..eedaeaf 100644
> >> --- a/net/can/j1939/transport.c
> >> +++ b/net/can/j1939/transport.c
> >> @@ -1789,6 +1789,7 @@ static void j1939_xtp_rx_dpo(struct j1939_priv *priv, struct sk_buff *skb,
> >>  static void j1939_xtp_rx_dat_one(struct j1939_session *session,
> >>  				 struct sk_buff *skb)
> >>  {
> >> +	enum j1939_xtp_abort abort = J1939_XTP_ABORT_FAULT;
> >>  	struct j1939_priv *priv = session->priv;
> >>  	struct j1939_sk_buff_cb *skcb, *se_skcb;
> >>  	struct sk_buff *se_skb = NULL;
> >> @@ -1803,9 +1804,11 @@ static void j1939_xtp_rx_dat_one(struct j1939_session *session,
> >>  
> >>  	skcb = j1939_skb_to_cb(skb);
> >>  	dat = skb->data;
> >> -	if (skb->len <= 1)
> >> +	if (skb->len != 8) {
> >>  		/* makes no sense */
> >> +		abort = J1939_XTP_ABORT_UNEXPECTED_DATA;
> >>  		goto out_session_cancel;
> > 
> > I think this is a situation of
> > "be strict on what you send, be tolerant on what you receive".
> > 
> > Did you find a technical reason to abort a session because the last frame didn't
> > bring overhead that you don't use?
> 
> No technical reason. The only reason is that SAE-J1939-82 requires responder
> to abort session if any TP.DT less than 8 bytes (section A.3.4, Row 7).

Do you mean: "BAM Transport: Ensure DUT discards BAM transport when
TP.DT data packets are not correct size" ... "Verify DUT discards the
BAM transport if any TP.DT data packet has less than 8 bytes"?

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
