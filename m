Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D52143C2551
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 15:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231942AbhGIN51 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 09:57:27 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:37484
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231454AbhGIN51 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 09:57:27 -0400
X-Greylist: delayed 512 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Jul 2021 09:57:27 EDT
Received: from [10.172.193.212] (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 40B024022A;
        Fri,  9 Jul 2021 13:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1625838370;
        bh=3ekPKtRlSLe5R2jClUwf0fuz6H5mk4TlWMoIZzUjV90=;
        h=To:From:Subject:Message-ID:Date:MIME-Version:Content-Type;
        b=mrGGfNbvP0awLpepuqZYTSWIq8RHw/T5fikiNNbDHS5UNK1G1KG/sXluk/g2dWJhs
         l0RtwTEDsfHYehtmxEIZanQNHzjJ/erq2sechGYYy2izvB57wWF0ejvonjKaxDc3kc
         tAlW1wQjoJn1+EMDelac6NCx3/KenZzT1P3/FUN6BPwLIMO3V+uSAsLlOPfcdNN73b
         WOZSfus0RWudp2VcCCRwUjlVHE/MkTAdfkxqrllgDfJaj9Zv6nIgnhwsAhuQykd2p/
         p2i7ySJgqBA4z2qKXYwEomKgKdWoh1pvH+vT5Fo0xlN7ASOkmGGSBt0ZD/YZWkIfu6
         ucu8p4nCM/jAA==
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From:   Colin Ian King <colin.king@canonical.com>
Subject: issue with set_vlan_mode in starfire driver
Message-ID: <31f2b9a1-19e8-e6db-6af8-77db17864dbb@canonical.com>
Date:   Fri, 9 Jul 2021 14:46:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Static analysis with Coverity on the starfire driver has detected an
issue introduced in function set_vlan_mode with the following commit:

commit 5da96be53a16a62488316810d0c7c5d58ce3ee4f
Author: Jiri Pirko <jpirko@redhat.com>
Date:   Wed Jul 20 04:54:31 2011 +0000

    starfire: do vlan cleanup

The analysis is as follows:

1743 static u32 set_vlan_mode(struct netdev_private *np)
1744 {
1745        u32 ret = VlanMode;
1746        u16 vid;
1747        void __iomem *filter_addr = np->base + HashTable + 8;
1748        int vlan_count = 0;
1749
1750        for_each_set_bit(vid, np->active_vlans, VLAN_N_VID) {
1751                if (vlan_count == 32)
1752                        break;
1753                writew(vid, filter_addr);
1754                filter_addr += 16;
1755                vlan_count++;
1756        }

cond_const: Condition vlan_count == 32, taking true branch. Now the
value of vlan_count is equal to 32.

1757        if (vlan_count == 32) {
1758                ret |= PerfectFilterVlan;

const: At condition vlan_count < 32, the value of vlan_count must be
equal to 32.
dead_error_condition: The condition vlan_count < 32 cannot be true.

1759                while (vlan_count < 32) {

Logically dead code (DEADCODE)
dead_error_begin: Execution cannot reach this statement: writew(0,
filter_addr);.

1760                        writew(0, filter_addr);
1761                        filter_addr += 16;
1762                        vlan_count++;
1763                }
1764        }
1765        return ret;
1766 }

Looking at commit 5da96be53a16a62488316810d0c7c5d58ce3ee4f it appears
that the check if (vlan_count == 32) should be if (vid == VLAN_N_VID) if
I understand things correctly.

However, I'm not sure about the setting of ret |= PerfectFilterVlan -
should that be set if the vlan_count reaches 32 or if vid reaches
VLAN_N_VID.  I don't understand the semantics of setting the
PerfectFilterVlan bit so I'm a bit stuck at figuring out an appropriate fix.

Thought had better flag this up as an issue since I can't resolve it.

Colin

