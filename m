Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67EC442A1EF
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 12:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235951AbhJLKXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 06:23:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235903AbhJLKXr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 06:23:47 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8AFFC061570
        for <netdev@vger.kernel.org>; Tue, 12 Oct 2021 03:21:45 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1maEuc-0003e5-Fb; Tue, 12 Oct 2021 12:21:34 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1maEuZ-0004HC-3P; Tue, 12 Oct 2021 12:21:31 +0200
Date:   Tue, 12 Oct 2021 12:21:31 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Maxime Jayat <maxime.jayat@mobile-devices.fr>,
        Robin van der Gracht <robin@protonic.nl>,
        linux-kernel@vger.kernel.org,
        Oleksij Rempel <linux@rempel-privat.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>, kernel@pengutronix.de,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        linux-can@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net] can: j1939: j1939_xtp_rx_dat_one(): cancel session
 if receive TP.DT with error length
Message-ID: <20211012102131.GA14971@pengutronix.de>
References: <1632972800-45091-1-git-send-email-zhangchangzhong@huawei.com>
 <20210930074206.GB7502@x1.vandijck-laurijssen.be>
 <1cab07f2-593a-1d1c-3a29-43ee9df4b29e@huawei.com>
 <20211008110007.GE29653@pengutronix.de>
 <556a04ed-c350-7b2b-5bbe-98c03846630b@huawei.com>
 <20211011063507.GI29653@pengutronix.de>
 <7b1b2e47-46e6-acec-5858-fae77266cec8@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7b1b2e47-46e6-acec-5858-fae77266cec8@huawei.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:17:56 up 236 days, 13:41, 138 users,  load average: 0.08, 0.29,
 0.41
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 11, 2021 at 06:40:15PM +0800, Zhang Changzhong wrote:
> On 2021/10/11 14:35, Oleksij Rempel wrote:
> > On Sat, Oct 09, 2021 at 04:43:56PM +0800, Zhang Changzhong wrote:
> >> On 2021/10/8 19:00, Oleksij Rempel wrote:
> >>> On Fri, Oct 08, 2021 at 05:22:12PM +0800, Zhang Changzhong wrote:
> >>>> Hi Kurt,
> >>>> Sorry for the late reply.
> >>>>
> >>>> On 2021/9/30 15:42, Kurt Van Dijck wrote:
> >>>>> On Thu, 30 Sep 2021 11:33:20 +0800, Zhang Changzhong wrote:
> >>>>>> According to SAE-J1939-21, the data length of TP.DT must be 8 bytes, so
> >>>>>> cancel session when receive unexpected TP.DT message.
> >>>>>
> >>>>> SAE-j1939-21 indeed says that all TP.DT must be 8 bytes.
> >>>>> However, the last TP.DT may contain up to 6 stuff bytes, which have no meaning.
> >>>>> If I remember well, they are even not 'reserved'.
> >>>>
> >>>> Agree, these bytes are meaningless for last TP.DT.
> >>>>
> >>>>>
> >>>>>>
> >>>>>> Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
> >>>>>> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> >>>>>> ---
> >>>>>>  net/can/j1939/transport.c | 7 +++++--
> >>>>>>  1 file changed, 5 insertions(+), 2 deletions(-)
> >>>>>>
> >>>>>> diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
> >>>>>> index bb5c4b8..eedaeaf 100644
> >>>>>> --- a/net/can/j1939/transport.c
> >>>>>> +++ b/net/can/j1939/transport.c
> >>>>>> @@ -1789,6 +1789,7 @@ static void j1939_xtp_rx_dpo(struct j1939_priv *priv, struct sk_buff *skb,
> >>>>>>  static void j1939_xtp_rx_dat_one(struct j1939_session *session,
> >>>>>>  				 struct sk_buff *skb)
> >>>>>>  {
> >>>>>> +	enum j1939_xtp_abort abort = J1939_XTP_ABORT_FAULT;
> >>>>>>  	struct j1939_priv *priv = session->priv;
> >>>>>>  	struct j1939_sk_buff_cb *skcb, *se_skcb;
> >>>>>>  	struct sk_buff *se_skb = NULL;
> >>>>>> @@ -1803,9 +1804,11 @@ static void j1939_xtp_rx_dat_one(struct j1939_session *session,
> >>>>>>  
> >>>>>>  	skcb = j1939_skb_to_cb(skb);
> >>>>>>  	dat = skb->data;
> >>>>>> -	if (skb->len <= 1)
> >>>>>> +	if (skb->len != 8) {
> >>>>>>  		/* makes no sense */
> >>>>>> +		abort = J1939_XTP_ABORT_UNEXPECTED_DATA;
> >>>>>>  		goto out_session_cancel;
> >>>>>
> >>>>> I think this is a situation of
> >>>>> "be strict on what you send, be tolerant on what you receive".
> >>>>>
> >>>>> Did you find a technical reason to abort a session because the last frame didn't
> >>>>> bring overhead that you don't use?
> >>>>
> >>>> No technical reason. The only reason is that SAE-J1939-82 requires responder
> >>>> to abort session if any TP.DT less than 8 bytes (section A.3.4, Row 7).
> >>>
> >>> Do you mean: "BAM Transport: Ensure DUT discards BAM transport when
> >>> TP.DT data packets are not correct size" ... "Verify DUT discards the
> >>> BAM transport if any TP.DT data packet has less than 8 bytes"?
> >>
> >> Yes.
> > 
> > OK, then I have some problems to understand this part:
> > - 5.10.2.4 Connection Closure
> >   The “connection abort” message is not allowed to be used by responders in the
> >   case of a global destination (i.e. BAM).
> > 
> > My assumption would be: In case of broadcast transfer, multiple MCU are
> > receivers. If one of MCU was not able to get complete TP.DT, it should
> > not abort BAM for all.
> > 
> > So, "DUT discards the BAM transport" sounds for me as local action.
> > Complete TP would be dropped locally.
> 
> Yeah, you are right. With this patch receivers drop BAM transport locally
> because j1939_session_cancel() only send abort message in RTS/CTS transport.
> 
> For RTS/CTS transport, SAE-J1939-82 also has similar requirements:
> "RTS/CTS Transport: Data field size of Transport Data packets for RTS/CTS
> (DUT as Responder)"..."Verify DUT behavior, e.g., sends a TP.CM_CTS to have
> packets resent or sends a TP.Conn_Abort, when it receives TP.DT data packets
> with less than 8 bytes" (section A.3.6, Row 18)

You are right. Sounds plausible. If we find some device in the field
which will need a workaround to support less than 8byte, then we will
need to add some UAPI to configure it. By default we should follow the
spec. @Kurt, do you have anything against it?

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
