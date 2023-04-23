Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65A7C6EC0C9
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 17:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbjDWPXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 11:23:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbjDWPXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 11:23:18 -0400
Received: from sender3-op-o18.zoho.com (sender3-op-o18.zoho.com [136.143.184.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7444E10DF
        for <netdev@vger.kernel.org>; Sun, 23 Apr 2023 08:23:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1682263372; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=QZ4mHqGiJXN9a7r4OEf67gaIeLedcsn0PuBa1JVGJ8GVPEPhRIISwW6wbSaMH561WpUuRBkLXcWn5w2FFc9HWbxm89dENPnDE5gC6RL6dRzHEWqChg2rSLmJW9ba4JYqPH0URWPTZvohogRQDsapPeS4COk8DJ2bmbmmSUBjYFU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1682263372; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=bOwyzvUWuea3fKw/1hIq9UY42voPh7kPGGj3aU4yNlI=; 
        b=BguTFac0aY6hcFSzjhzs3PR4vOMTCQJPpTx72PP9s3+jSC+vkkbwEsTKnDdk9Ue6HtGRqZJgMJvbH1dRTicDaUrxz3oy33xXhTZDeTVLT2om7xJZPSYIvF8VBClnhpIf+hAkr+fmfOYS4z7rTfF1K3MPBwipUP8SiR7pZuYfdxE=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1682263372;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:To:To:From:From:Subject:Subject:Cc:Cc:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=bOwyzvUWuea3fKw/1hIq9UY42voPh7kPGGj3aU4yNlI=;
        b=Eb/nBJQjJjov8bNgBhBpL754EcCUiCyP34wV4ZPdpCWxCm2X25jlH8g6AhZYaxia
        yTuD481S3EzksJ2Ksj8UDhPFuWP2ITR8WkQoFugGZ4ujs2DiKkWEYYnp85DQtXTR0g7
        DaotFdFB8qyCcW+yo726TLxGP/MjjcnhySGbF9bY=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 1682263369793310.927066884233; Sun, 23 Apr 2023 08:22:49 -0700 (PDT)
Message-ID: <8a955c34-5724-af9d-d828-a8786bcc08b0@arinc9.com>
Date:   Sun, 23 Apr 2023 18:22:41 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Greg Ungerer <gerg@kernel.org>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Subject: MT7530 bug, forward broadcast and unknown frames to the correct CPU
 port
Cc:     Daniel Golle <daniel@makrotopia.org>,
        Richard van Schagen <richard@routerhints.com>,
        Richard van Schagen <vschagen@cs.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        erkin.bozoglu@xeront.com, bartel.eerdekens@constell8.be,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey there folks,

On mt753x_cpu_port_enable() there's code [0] that sets which port to 
forward the broadcast, unknown multicast, and unknown unicast frames to. 
Since mt753x_cpu_port_enable() runs twice when both CPU ports are 
enabled, port 6 becomes the port to forward the frames to. But port 5 is 
the active port, so no broadcast frames received from the user ports 
will be forwarded to port 5. This breaks network connectivity when 
multiple ports are being used as CPU ports.

My testing shows that only after receiving a broadcast ARP frame from 
port 5 then forwarding it to the user port, the unicast frames received 
from that user port will be forwarded to port 5. I tested this with ping.

Forwarding broadcast and unknown unicast frames to the CPU port was done 
with commit 5a30833b9a16 ("net: dsa: mt7530: support MDB and bridge flag 
operations"). I suppose forwarding the broadcast frames only to the CPU 
port is what "disable flooding" here means.

It’s a mystery to me how the switch classifies multicast and unicast 
frames as unknown. Bartel's testing showed LLDP frames fall under this 
category.

Until the driver supports changing the DSA conduit, unknown frames 
should be forwarded to the active CPU port, not the numerically greater 
one. Any ideas how to address this and the "disable flooding" case?

There's also this "set the CPU number" code that runs only for MT7621. 
I'm not sure why this is needed or why it's only needed for MT7621. 
Greg, could you shed some light on this since you added this code with 
commit ddda1ac116c8 ("net: dsa: mt7530: support the 7530 switch on the 
Mediatek MT7621 SoC")?

There're more things to discuss after supporting changing the DSA 
conduit, such as which CPU port to forward the unknown frames to, when 
user ports under different conduits receive unknown frames. What makes 
sense to me is, if there are multiple CPU ports being used, forward the 
unknown frames to port 6. This is already the case except the code runs 
twice. If not, set it to whatever 'int port' is, which is the default 
behaviour already.

[0] 
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/drivers/net/dsa/mt7530.c#n1005

Arınç
