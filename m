Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3EE65C227
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 15:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233618AbjACOnS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 09:43:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237763AbjACOnB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 09:43:01 -0500
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E170BEE15;
        Tue,  3 Jan 2023 06:42:59 -0800 (PST)
Received: from [IPV6:2003:e9:d713:1514:accc:688a:efc9:2199] (p200300e9d7131514accc688aefc92199.dip0.t-ipconnect.de [IPv6:2003:e9:d713:1514:accc:688a:efc9:2199])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id A632EC016C;
        Tue,  3 Jan 2023 15:42:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1672756978;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iycX61ZLgijIWaaHytHXbcnm9MJgdCBTIoH1EwQ5jl0=;
        b=j4XqF/WGuAk8suTGHrR6LeoTw8iN44Qt5WxuxO3MvxMaPxKOFjUJl+HOhaBp7YCrKQy0fU
        +bVEZdTWiI9KwBsO7u6OrCag8tlQb3BDdZbLi+oLgH99GDGd2KmIPG2YNa8vO8meHeupL8
        r10WVn6dUJcS6JyceiCRFnRSWRH8vAZJLLPhqBkj/utRsREKUMDWUjMXbO6HhIcm14MbpC
        X3AwZ94XP3uhoUGsBCFdVDRGfKL8Oxhtb2/SwdecTuBR0kXmp84XKVwN3iQULhtuQtN2GA
        4zShsxP6qJs+rSxWwK+p0SuXY/zr7af7uelXNh7IAMhfwRfrc17tl6h2w8NI+w==
Message-ID: <71a95ec1-a7c9-fc92-ddb2-4ada4df4ec01@datenfreihafen.org>
Date:   Tue, 3 Jan 2023 15:42:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH wpan-next v2 6/6] mac802154: Handle passive scanning
Content-Language: en-US
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Alexander Aring <alex.aring@gmail.com>,
        linux-wpan@vger.kernel.org
Cc:     David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
References: <20221217000226.646767-1-miquel.raynal@bootlin.com>
 <20221217000226.646767-7-miquel.raynal@bootlin.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20221217000226.646767-7-miquel.raynal@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Miquel

On 17.12.22 01:02, Miquel Raynal wrote:
> Implement the core hooks in order to provide the softMAC layer support
> for passive scans. Scans are requested by the user and can be aborted.
> 
> Changing channels manually is prohibited during scans.
> 
> The implementation uses a workqueue triggered at a certain interval
> depending on the symbol duration for the current channel and the
> duration order provided. More advanced drivers with internal scheduling
> capabilities might require additional care but there is none mainline
> yet.
> 
> Received beacons during a passive scan are processed in a work queue and
> their result forwarded to the upper layer.
> 
> Active scanning is not supported yet.
> 
> Co-developed-by: David Girault <david.girault@qorvo.com>
> Signed-off-by: David Girault <david.girault@qorvo.com>
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
>   include/linux/ieee802154.h   |   4 +
>   include/net/cfg802154.h      |  16 ++
>   net/mac802154/Makefile       |   2 +-
>   net/mac802154/cfg.c          |  31 ++++
>   net/mac802154/ieee802154_i.h |  37 ++++-
>   net/mac802154/iface.c        |   3 +
>   net/mac802154/main.c         |  16 +-
>   net/mac802154/rx.c           |  36 ++++-
>   net/mac802154/scan.c         | 289 +++++++++++++++++++++++++++++++++++
>   9 files changed, 428 insertions(+), 6 deletions(-)
>   create mode 100644 net/mac802154/scan.c

Checkpatch found another set of problematic indents in this one:

Commit 216e51c90975 ("mac802154: Handle passive scanning")
----------------------------------------------------------
WARNING: added, moved or deleted file(s), does MAINTAINERS need updating?
#361:
new file mode 100644

WARNING: networking block comments don't use an empty /* line, use /* 
Comment...
#385: FILE: net/mac802154/scan.c:20:
+/*
+ * mac802154_scan_cleanup_locked() must be called upon scan completion 
or abort.

ERROR: code indent should use tabs where possible
#475: FILE: net/mac802154/scan.c:110:
+                                struct cfg802154_scan_request *scan_req,$

WARNING: please, no spaces at the start of a line
#475: FILE: net/mac802154/scan.c:110:
+                                struct cfg802154_scan_request *scan_req,$

ERROR: code indent should use tabs where possible
#479: FILE: net/mac802154/scan.c:114:
+        *channel = find_next_bit((const unsigned long 
*)&scan_req->channels,$

WARNING: please, no spaces at the start of a line
#479: FILE: net/mac802154/scan.c:114:
+        *channel = find_next_bit((const unsigned long 
*)&scan_req->channels,$

ERROR: code indent should use tabs where possible
#485: FILE: net/mac802154/scan.c:120:
+                                         struct cfg802154_scan_request 
*scan_req,$

WARNING: please, no spaces at the start of a line
#485: FILE: net/mac802154/scan.c:120:
+                                         struct cfg802154_scan_request 
*scan_req,$

ERROR: code indent should use tabs where possible
#486: FILE: net/mac802154/scan.c:121:
+                                         u8 page, u8 *channel)$

WARNING: please, no spaces at the start of a line
#486: FILE: net/mac802154/scan.c:121:
+                                         u8 page, u8 *channel)$

ERROR: "foo* bar" should be "foo *bar"
#502: FILE: net/mac802154/scan.c:137:
+	struct wpan_phy* wpan_phy;

ERROR: code indent should use tabs where possible
#539: FILE: net/mac802154/scan.c:174:
+                ret = mac802154_scan_find_next_chan(local, scan_req, 
page, &channel);$

WARNING: please, no spaces at the start of a line
#539: FILE: net/mac802154/scan.c:174:
+                ret = mac802154_scan_find_next_chan(local, scan_req, 
page, &channel);$

ERROR: code indent should use tabs where possible
#540: FILE: net/mac802154/scan.c:175:
+                if (ret) {$

WARNING: please, no spaces at the start of a line
#540: FILE: net/mac802154/scan.c:175:
+                if (ret) {$

ERROR: code indent should use tabs where possible
#542: FILE: net/mac802154/scan.c:177:
+                        goto end_scan;$

WARNING: please, no spaces at the start of a line
#542: FILE: net/mac802154/scan.c:177:
+                        goto end_scan;$

ERROR: code indent should use tabs where possible
#543: FILE: net/mac802154/scan.c:178:
+                }$

WARNING: please, no spaces at the start of a line
#543: FILE: net/mac802154/scan.c:178:
+                }$

ERROR: code indent should use tabs where possible
#544: FILE: net/mac802154/scan.c:179:
+        } while (!ieee802154_chan_is_valid(scan_req->wpan_phy, page, 
channel));$

WARNING: please, no spaces at the start of a line
#544: FILE: net/mac802154/scan.c:179:
+        } while (!ieee802154_chan_is_valid(scan_req->wpan_phy, page, 
channel));$

ERROR: code indent should use tabs where possible
#546: FILE: net/mac802154/scan.c:181:
+        rcu_read_unlock();$

WARNING: please, no spaces at the start of a line
#546: FILE: net/mac802154/scan.c:181:
+        rcu_read_unlock();$

ERROR: code indent should use tabs where possible
#553: FILE: net/mac802154/scan.c:188:
+                dev_err(&sdata->dev->dev,$

WARNING: please, no spaces at the start of a line
#553: FILE: net/mac802154/scan.c:188:
+                dev_err(&sdata->dev->dev,$

ERROR: code indent should use tabs where possible
#554: FILE: net/mac802154/scan.c:189:
+                        "Channel change failure during scan, aborting 
(%d)\n", ret);$

WARNING: please, no spaces at the start of a line
#554: FILE: net/mac802154/scan.c:189:
+                        "Channel change failure during scan, aborting 
(%d)\n", ret);$

ERROR: code indent should use tabs where possible
#565: FILE: net/mac802154/scan.c:200:
+                dev_err(&sdata->dev->dev,$

WARNING: please, no spaces at the start of a line
#565: FILE: net/mac802154/scan.c:200:
+                dev_err(&sdata->dev->dev,$

ERROR: code indent should use tabs where possible
#566: FILE: net/mac802154/scan.c:201:
+                        "Restarting failure after channel change, 
aborting (%d)\n", ret);$

WARNING: please, no spaces at the start of a line
#566: FILE: net/mac802154/scan.c:201:
+                        "Restarting failure after channel change, 
aborting (%d)\n", ret);$

total: 15 errors, 16 warnings, 0 checks, 558 lines checked

regards
Stefan Schmidt
