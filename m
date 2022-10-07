Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A61F25F7916
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 15:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbiJGNfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 09:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbiJGNfh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 09:35:37 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D21792599
        for <netdev@vger.kernel.org>; Fri,  7 Oct 2022 06:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=c0igupCnq8/BSZb485JtgpOsvaCMPns8KSgeMH7LYBU=;
        t=1665149733; x=1666359333; b=wNLjKZcSzgdQnrUZp3ttPToL7ITHfuG/w3Wpr8XnehCpDHI
        /8emC85V7IpicpSbc071B+5vdomAHm2JDoCDizfIfdJDF5hSagPPelPOqMHCrg4XbV3xynNaDlsrH
        fbYr7qY+plkE6sDT/geauJAyirLuUyQUDwWoS+DUDyQ0Z38h6MWABGPrcVDUV5L3neDXo/qDI2HHm
        rOgmUAlvWBTw/x5h3yMvAvj+muCcCasJzOmDh1jBp2kczrzkRyRWDBPTWy1elvgJ5IH8HW2pzzqlQ
        Ddh4NIxvUcqHbUtxaT3P96FOWlcu1mhzaasDyS6VAwNF6FyMId2bQd+Xro+S7Gsg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1ognVi-000OhX-2a;
        Fri, 07 Oct 2022 15:35:30 +0200
Message-ID: <34a347be9efca63a76faf6edca6e313b257483b6.camel@sipsolutions.net>
Subject: Re: [RFC PATCH net-next 1/3] netlink: add support for formatted
 extack messages
From:   Johannes Berg <johannes@sipsolutions.net>
To:     ecree@xilinx.com, netdev@vger.kernel.org, linux-net-drivers@amd.com
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, habetsm.xilinx@gmail.com,
        marcelo.leitner@gmail.com, Edward Cree <ecree.xilinx@gmail.com>
Date:   Fri, 07 Oct 2022 15:35:29 +0200
In-Reply-To: <a01a9a1539c22800b2a5827cf234756f13fa6b97.1665147129.git.ecree.xilinx@gmail.com>
References: <cover.1665147129.git.ecree.xilinx@gmail.com>
         <a01a9a1539c22800b2a5827cf234756f13fa6b97.1665147129.git.ecree.xilinx@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> +#define NL_SET_ERR_MSG_FMT(extack, fmt, args...) do {		\
> +	struct netlink_ext_ack *__extack =3D (extack);		\
> +								\
> +	scnprintf(__extack->_msg_buf, NETLINK_MAX_FMTMSG_LEN,	\
> +		  (fmt), ##args);				\

Maybe that should print some kind of warning if the string was longer
than the buffer? OTOH, I guess the user would notice anyway, and until
you run the code nobody can possibly notice ... too bad then?

Maybe we could at least _statically_ make sure that the *format* string
(fmt) is shorter than say 60 chars or something to give some wiggle room
for the print expansion?

	/* allow 20 chars for format expansion */
	BUILD_BUG_ON(strlen(fmt) > NETLINK_MAX_FMTMSG_LEN - 20);

might even work? Just as a sanity check.

> +	do_trace_netlink_extack(__extack->_msg_buf);		\
> +								\
> +	if (__extack)						\
> +		__extack->_msg =3D __extack->_msg_buf;		\

That "if (__extack)" check seems a bit strange, you've long crashed with
a NPD if it was really NULL?

johannes
