Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD891A22C7
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 15:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728699AbgDHNPy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 09:15:54 -0400
Received: from forward106p.mail.yandex.net ([77.88.28.109]:49781 "EHLO
        forward106p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726709AbgDHNPx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 09:15:53 -0400
X-Greylist: delayed 490 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Apr 2020 09:15:52 EDT
Received: from mxback28o.mail.yandex.net (mxback28o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::79])
        by forward106p.mail.yandex.net (Yandex) with ESMTP id 91D061C82784;
        Wed,  8 Apr 2020 16:07:41 +0300 (MSK)
Received: from myt5-1ebfaac9e69d.qloud-c.yandex.net (myt5-1ebfaac9e69d.qloud-c.yandex.net [2a02:6b8:c12:3b2d:0:640:1ebf:aac9])
        by mxback28o.mail.yandex.net (mxback/Yandex) with ESMTP id tqvAghk8Sy-7eEeVahx;
        Wed, 08 Apr 2020 16:07:40 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1586351260;
        bh=jrhvQX2sLls23iW+V5gd/bQZMasyl2KoWjsNDHdfKEE=;
        h=Subject:From:To:Cc:Date:Message-ID;
        b=cKqeV25XkQ0GdDCbuWVmvufzkhon1C3EajirmogThpQEZtAukVza8Mg2OwG8taLsT
         lgUK3mIsJkbDlE8h6pc9WsVpgGKgmDEC89dqUxi1aDjmWNYmgFdXAPrMhVaK5CwQHH
         U5gmkTKUCD2X9ZUNm159pvahe2uBWvyikRrgdw74=
Authentication-Results: mxback28o.mail.yandex.net; dkim=pass header.i=@yandex.ru
Received: by myt5-1ebfaac9e69d.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id 2hhiXuqWSj-7dYORdnY;
        Wed, 08 Apr 2020 16:07:39 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
To:     netdev@vger.kernel.org
Cc:     linville@tuxdriver.com
From:   Konstantin Kharlamov <hi-angel@yandex.ru>
Subject: (repost for 2020y) inconsistency of ethtool feature names for get vs.
 set
Message-ID: <36ca2996-ea04-f050-5f88-7edef5a88f26@yandex.ru>
Date:   Wed, 8 Apr 2020 16:07:39 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB-large
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I just started using the -K and -k options, and I was very confused why nothing I was trying worked. I followed the documentation, which says that there're predefined options, (e.g. gso, gro) but kernel may also define others. And according to the `-k` output, sure they were, like "generic-segmentation-offload" and "large-receive-offload"! Well, at least I thought so.

Researching the internet led me to the old report of this behavior. So, it was already discussed in 2014, someone got a patch to fix this, and everyone was happy. The patch has never made it into the discussion though.

I figured, the project has no bugtracker, so once discussion stopped, a report is lost. I guess, 6 years is a big enough timespan to consider a discussion stopped, so I'm bringing it up again. What follows is a copy of the report here https://www.spinics.net/lists/netdev/msg264222.html

P.S.: please add me to CC, I'm not subscribed to the list.

------

Hi Ben,

I noticed some inconsistency of feature names with the ethtool getting/setting of features mechanics -- the name of the feature you need to set (through -K) isn't what displayed by the get (-k) directive, here's an example:

$ ethtool -k eth1  | grep generic-receive-offload
generic-receive-offload: on

$ ethtool -K eth1  generic-receive-offload off
ethtool: bad command line argument(s)
For more information run ethtool -h

--> looking in the sources and realizing I need to use "rx-gro"

$ ethtool -K eth1  rx-gro on

$ethtool -k eth1  | grep generic-receive-offload
generic-receive-offload: on

same problem for rx checksum which is displayed as "rx-checksumming" by the get (-k)
but need to be "rx-checksum" for the set (-K) directive.
