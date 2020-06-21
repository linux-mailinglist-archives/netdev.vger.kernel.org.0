Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81282202DA0
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 01:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730869AbgFUXTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 19:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726588AbgFUXTW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jun 2020 19:19:22 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F39C061794
        for <netdev@vger.kernel.org>; Sun, 21 Jun 2020 16:19:22 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id i3so1882034qtq.13
        for <netdev@vger.kernel.org>; Sun, 21 Jun 2020 16:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=/nJZItB4Dfa8vKhiYVgPlS63Gp++nsFSFrPWBgr+p/4=;
        b=mo5vaY6Se8XCdltleao3pzcDOeVW95qafXE9GUyPDvf3YiFb4bL49Pv7bRyWazdbTo
         dLkSfoLLbE1x4aZtvfoJEiMXiTK4SPFaDX16sMIse8EexHA8KjhoZtbazLnUwms/Qn8i
         2t5xfy1ZFMuPlsTL74Lc0DkFXsR8Ew5K5vO6uoHvzKi2mcRZ9xyiyHZVpAAdEXg7iBdg
         Ad1zHfPGvJXjORUhom/z3oIj7+sMuvMdyuknX0BgVtl6QHU+RqkQqCfdoMEPf3x94lFV
         kJI3C17fZJIMF9JQ79oq8LdeOJdw7WtCjuCok94rk3k4XJj/IaUOp+CkG34pwYgwZvkc
         99AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=/nJZItB4Dfa8vKhiYVgPlS63Gp++nsFSFrPWBgr+p/4=;
        b=LLCnaC/ITIUwykF1BJQV+c5t1OctJ89opvZ78J7VCZDT5/7gwVudXAliqg3r2rcZy1
         Szc8FHIsnCz0X6SgSHKaxPV20/SVncu047omc269vggaIuIZoC1eDSdl5B0suBbV7mDF
         BRiqi7joujWS30OA55IzxuwqsKW6IEH2PXkf72xu8AFccoULbg5Z1MLRk4XnyFHdT/J5
         QYhN36xwIVQtpt7KuC5f4KksxfV5a8c8CXcusQPPzY4KF/BNxiKYe+k3MIO968cwcZW9
         AS5PICx6Lstkc8wsh5LjverjL0CVU+hmGABpEAoTdLs/axz79YohQI1r3Sx1NC8zMP8i
         LUoA==
X-Gm-Message-State: AOAM531EmpyPmIR6RMFzhBOPfpyJIRS4CnriJ0xextcdeA9xpnlfQHgJ
        Z6r6pLOWbi9DsYZNwOU9RgF31gTffLhnjhEkmVWCo6SBnJw=
X-Google-Smtp-Source: ABdhPJzgA3BiL3H1MolpAL7Pbw9rDxITTwg8obLo7kdRaXldamBXoUgx3BKsp6KSHjwZDEnrYPRrGjOcT0P9cCnqxe0=
X-Received: by 2002:aed:221a:: with SMTP id n26mr7814551qtc.8.1592781561171;
 Sun, 21 Jun 2020 16:19:21 -0700 (PDT)
MIME-Version: 1.0
From:   Qiwei Wen <wenqiweiabcd@gmail.com>
Date:   Mon, 22 Jun 2020 09:19:10 +1000
Message-ID: <CADxRGxBfaWWvtYJmEebdzSMkVk6-YTx+jff2bGwS+TXBUPM-LA@mail.gmail.com>
Subject: Multicast routing: wrong output interface selected unless VRF default
 route is added
To:     netdev@vger.kernel.org
Content-Type: multipart/mixed; boundary="00000000000028b26c05a8a05b74"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000028b26c05a8a05b74
Content-Type: text/plain; charset="UTF-8"

Hi all,

While experimenting with FRRouting, I observed the following
behaviour. I'm not sure whether it's intended or not.

In a virtual machine set up as a multicast router, I added two
networks, created a VRF, and enslaved interfaces to both networks to
the VRF, like so:

ip link add blue type vrf table 1001
ip link set eth0 master blue
ip link set eth1 master blue

I then set up PIM on the router VM (FRR configs attached) and started
the multicast sender and receiver processes on two other VMs. The
mroutes came up as expected (ip show mroute table 1001), but no
packets came to the receiver. I added the following debug message to
ipmr_queue_xmit, just before the NF_HOOK macro:

+    pr_info("calling NF_HOOK! vif->dev is %s,"
+            " dev is %s, skb->dev is %s\n",
+            vif->dev->name, dev->name, skb->dev->name);

and I found that "dev", the selected output interface, is in fact the
output interface of the main table (unicast) default route. Running
tcpdump on that (very wrong) output interface confirmed this.

I then went back to networking/vrf.txt, and found that I forgot to do this:

ip route add table 1001 unreachable default metric 4278198272

after this step, multicast routing began to work correctly.

Further debugging-by-printk lead to these observations:
1. Using the main table (without VRFs), multicast routing works fine
with or without the default unicast route; but in the function "
ip_route_output_key_hash_rcu", the call to "fib_lookup" in fact fails
with -101, "network unreachable".
2. Using the VRF table 1001, the kernel stops routing multicast
packets to the wrong interface once the unreachable default route is
added. "fib_lookup" continues to fail, but with -113, "host
unreachable".

My questions are:
1. is fib_lookup supposed to work with multicast daddr? If so, has
multicast routing been working for the wrong reason?
2. Why does the addition of a unicast default route affect multicast
routing behaviour?

-Dave

--00000000000028b26c05a8a05b74
Content-Type: application/octet-stream; name=frr-runn
Content-Disposition: attachment; filename=frr-runn
Content-Transfer-Encoding: base64
Content-ID: <f_kbpp03w30>
X-Attachment-Id: f_kbpp03w30

IQpmcnIgdmVyc2lvbiA3LjMKZnJyIGRlZmF1bHRzIHRyYWRpdGlvbmFsCmhvc3RuYW1lIGRlYmlh
bgpsb2cgc3lzbG9nIGluZm9ybWF0aW9uYWwKbm8gaXB2NiBmb3J3YXJkaW5nCnNlcnZpY2UgaW50
ZWdyYXRlZC12dHlzaC1jb25maWcKIQp2cmYgYmx1ZQogaXAgcGltIHJwIDEwLjEuMi4yIDIyNC4w
LjAuMC80CiBleGl0LXZyZgohCmludGVyZmFjZSBlbnAwczggdnJmIGJsdWUKIGlwIGlnbXAKIGlw
IHBpbQohCmludGVyZmFjZSBlbnAwczkgdnJmIGJsdWUKIGlwIGlnbXAKIGlwIHBpbQohCmxpbmUg
dnR5CiEKZW5kCg==
--00000000000028b26c05a8a05b74--
