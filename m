Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DFE639DB38
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 13:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbhFGL2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 07:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbhFGL2P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 07:28:15 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6830C061766;
        Mon,  7 Jun 2021 04:26:24 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 75CCB22173;
        Mon,  7 Jun 2021 13:26:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1623065183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZB1kEjY2/j4tNhidAjSOjOaVBrtrrrTc3QaDeoaXG/4=;
        b=Pzrimpc4RtMjAxFsZKlot+mljm3uKrLaVVbAQ22cyHnx3/UKU4F+eeuhlPBEwHSyx9XZWt
        Ett11TC8Y/q96u3lE7HHjQk/FIC0BstS64ASHb5sqZnqVqgAShjspluD6JKzDtENZAilzL
        q40uBZd3xfFA3yQuvJtARNjgYHyehNo=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 07 Jun 2021 13:26:22 +0200
From:   Michael Walle <michael@walle.cc>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        UNGLinuxDriver@microchip.com, alexandre.belloni@bootlin.com,
        allan.nielsen@microchip.com,
        Claudiu Manoil <claudiu.manoil@nxp.com>, davem@davemloft.net,
        idosch@mellanox.com, joergen.andreasen@microchip.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Po Liu <po.liu@nxp.com>, vinicius.gomes@intel.com
Subject: Re: [net-next] net: dsa: felix: disable always guard band bit for TAS
 config
In-Reply-To: <20210507121909.ojzlsiexficjjjun@skbuf>
References: <c7618025da6723418c56a54fe4683bd7@walle.cc>
 <20210504185040.ftkub3ropuacmyel@skbuf>
 <ccb40b7fd18b51ecfc3f849a47378c54@walle.cc>
 <20210504191739.73oejybqb6z7dlxr@skbuf>
 <d933eef300cb1e1db7d36ca2cb876ef6@walle.cc>
 <20210504213259.l5rbnyhxrrbkykyg@skbuf>
 <efe5ac03ceddc8ff472144b5fe9fd046@walle.cc>
 <DB8PR04MB5785A6A773FEA4F3E0E77698F0579@DB8PR04MB5785.eurprd04.prod.outlook.com>
 <2898c3ae1319756e13b95da2b74ccacc@walle.cc>
 <DB8PR04MB5785D01D2F9091FB9267D515F0579@DB8PR04MB5785.eurprd04.prod.outlook.com>
 <20210507121909.ojzlsiexficjjjun@skbuf>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <07b1bc11eee83d724d4ddc4ee8378a12@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir, Hi Xiaoliang,

Am 2021-05-07 14:19, schrieb Vladimir Oltean:
> Devices like Felix need the per-queue max SDU from the
> user - if that isn's specified in the netlink message they'll have to
> default to the interface's MTU.

Btw. just to let you and Xiaoliang know:

It appears that PORT_MAX_SDU isn't working as expected. It is used
as a fallback if QMAXSDU_CFG_n isn't set for the guard band
calculation. But it appears to be _not_ used for discarding any
frames. E.g. if you set PORT_MAX_SDU to 500 the port will still
happily send frames larger than 500 bytes. (Unless of course
you hit the guard band of 500 bytes). OTOH QMAXSDU_CFG_n works
as expected, it will discard oversized frames - and presumly will
set the guard band accordingly, I haven't tested this explicitly.

Thus, I wonder what sense PORT_MAX_SDU makes at all. If you set
the guard band to a smaller value than the MTU, you'll also need
to make sure, there will be no larger frames scheduled on that port.

In any case, the workaround is to set QMAXSDU_CFG_n (for all
n=0..7) to the desired max_sdu value instead of using PORT_MAX_SDU.

It might also make sense to check with the IP supplier.

In the case anyone wants to implement that for (upstream) linux ;)

-michael
