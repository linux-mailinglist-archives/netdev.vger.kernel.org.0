Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54A3E196DD1
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 16:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728225AbgC2OJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 10:09:17 -0400
Received: from edrik.securmail.fr ([45.91.125.3]:36464 "EHLO
        edrik.securmail.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727903AbgC2OJQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 10:09:16 -0400
Received: by edrik.securmail.fr (Postfix, from userid 58)
        id CD233B0ECA; Sun, 29 Mar 2020 16:09:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=swordarmor.fr;
        s=swordarmor; t=1585490953;
        bh=ywOqlZ+VVMhbPCXPoLMGPA4ag8vy+lcYSTuvZK6+S8U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=CWPztbpuZDl34pv0vzpviJckyPy7vZL2c/RVovE/9yAjGTu/QJfsMdsuJUZIFCU8Y
         y3Kz79lVLl1aLX7e2gidnDr1u6uIQMSWCNuBo1kU3yxUatgucVejloHamL7ERXHlFE
         2fEfErFOsiAh4MoElF4wuupyVZH9cFvUJoedRC1M=
Received: from mew.swordarmor.fr (mew.swordarmor.fr [IPv6:2a00:5884:102:1::4])
        (using TLSv1.2 with cipher DHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: alarig@swordarmor.fr)
        by edrik.securmail.fr (Postfix) with ESMTPSA id 201CCB0EA2;
        Sun, 29 Mar 2020 16:09:11 +0200 (CEST)
Authentication-Results: edrik.securmail.fr/201CCB0EA2; dmarc=none (p=none dis=none) header.from=swordarmor.fr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=swordarmor.fr;
        s=swordarmor; t=1585490951;
        bh=ywOqlZ+VVMhbPCXPoLMGPA4ag8vy+lcYSTuvZK6+S8U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=mWScP02WI0m8zoHTOlmRciCqCa7noYGQRpm0LtbEb4QsXMSOurAvxKbvuwtRmKCJO
         SMAJDHPDVrCZUJmLAPferMNjavsNkd9NFigtv2J9zA8JffcnKcAeaVfLxqpKh5Gm1G
         jPnZjv+DfMZYnb47mfAn9aa56at+40CzYWDDNAtQ=
Date:   Sun, 29 Mar 2020 16:09:07 +0200
From:   Alarig Le Lay <alarig@swordarmor.fr>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, jack@basilfillan.uk,
        Vincent Bernat <bernat@debian.org>
Subject: Re: IPv6 regression introduced by commit
 3b6761d18bc11f2af2a6fc494e9026d39593f22c
Message-ID: <20200329140907.rhqjtdiqiyd37mlz@mew.swordarmor.fr>
References: <20200305081747.tullbdlj66yf3w2w@mew.swordarmor.fr>
 <d8a0069a-b387-c470-8599-d892e4a35881@gmail.com>
 <20200308105729.72pbglywnahbl7hs@mew.swordarmor.fr>
 <27457094-b62a-f029-e259-f7a274fee49d@gmail.com>
 <20200310103541.aplhwhfsvcflczhp@mew.swordarmor.fr>
 <92f8ca32-af23-effd-55d8-8d1065f644f8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <92f8ca32-af23-effd-55d8-8d1065f644f8@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On mar. 10 mars 09:27:53 2020, David Ahern wrote:
> Are the failing windows always ~30 seconds long?

It seems so. At least it’s a relaively fixed amout of time.

> How many ipv6 sockets are open? (ss -6tpn)

Only the BGP daemon.

root@hv03:~# ss -6tpn
State           Recv-Q           Send-Q                          Local Address:Port                            Peer Address:Port                                                     
ESTAB           0                0                          [2a00:5884:0:6::a]:55418                     [2a00:5884:0:6::2]:179            users:(("bird6",pid=1824,fd=10))          
ESTAB           0                0                          [2a00:5884:0:6::a]:56892                     [2a00:5884:0:6::1]:179            users:(("bird6",pid=1824,fd=11))          


> How many ipv6 neighbor entries exist? (ip -6 neigh sh)

root@hv03:~# ip -6 neigh sh
fe80::21b:21ff:fe48:6899 dev vmbr12 lladdr 00:1b:21:48:68:99 router DELAY
fe80::c8fd:83ff:fe88:7052 dev tap116i0 lladdr ca:fd:83:88:70:52 PERMANENT
2a00:5884:8204::1 dev vmbr1 lladdr ca:fd:83:88:70:52 STALE
fe80::5476:43ff:fe0f:209d dev vmbr0 lladdr 56:76:43:0f:20:9d STALE
fe80::3c19:f7ff:fe18:f9ca dev vmbr0 lladdr 3e:19:f7:18:f9:ca STALE
fe80::ecc0:e7ff:fe97:b4d9 dev vmbr0 lladdr ee:c0:e7:97:b4:d9 STALE
fe80::7a2b:cbff:fe4c:d537 dev vmbr13 lladdr 78:2b:cb:4c:d5:37 STALE
fe80::a093:a1ff:fe14:8c8a dev vmbr0 lladdr a2:93:a1:14:8c:8a STALE
fe80::9a4b:e1ff:fe64:b90 dev vmbr0 lladdr 98:4b:e1:64:0b:90 STALE
2a00:5884:0:6::2 dev vmbr12 lladdr 00:1b:21:48:68:99 router REACHABLE
fe80::5287:89ff:fef0:ce81 dev vmbr12 lladdr 50:87:89:f0:ce:81 router REACHABLE
fe80::c8fd:83ff:fe88:7052 dev vmbr1 lladdr ca:fd:83:88:70:52 STALE
2a00:5884:0:6::1 dev vmbr12 lladdr 50:87:89:f0:ce:81 router REACHABLE
fe80::7a2b:cbff:fe4c:d537 dev vmbr12 lladdr 78:2b:cb:4c:d5:37 STALE
fe80::7a2b:cbff:fe4c:d537 dev vmbr8 lladdr 78:2b:cb:4c:d5:37 STALE
fe80::5054:ff:fef9:192d dev vmbr0 lladdr 52:54:00:f9:19:2d STALE

Not so much either.


But the good news is that I have a work-around: adding
`net.ipv6.route.gc_thresh = -1` to sysctl.conf

I don’t know exactly what it does as it’s not documented, I just pick
the IPv4 value.

-- 
Alarig
