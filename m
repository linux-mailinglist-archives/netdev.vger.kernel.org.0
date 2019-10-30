Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00ED1EA3A3
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 19:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728276AbfJ3Svd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 14:51:33 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:38098 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726509AbfJ3Svc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 14:51:32 -0400
Received: by mail-io1-f68.google.com with SMTP id u8so3779432iom.5;
        Wed, 30 Oct 2019 11:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=PX5fsa+NLlEhxRi+aqxfpfq2rBqxuYpYJn1Xz9V0AUY=;
        b=CxVumV+XBy9uGmdvGG8bInnqyxuFa1P+NZHJERbxJvaLda9+eX1H7g4NBK85YS5vKE
         ZVUwHgT0VNYCf0kzh+EmlVNZ7M7kt+jDqJCnhbRlo81fcf1tUb2kddl7ncKXhTOvH1TK
         w1kw+rkz8JQyOI26ELJrFzhkBCyhhQv+weZhL8Cr1UZ5AzNoKoqHbwzySvpBINxTTnyP
         3djnOApZbC8sVK6fprXpFlw8KxqlxaVEgZYv2A9sy9I4u3LEEj7GPr+9sh2gpBu3MBHu
         8lQcZrU0RyvzasW7ucSeVhVwfS8rf1SYMFWCeBRaKUIDzioI66FQfALCjF2lihdqMFuB
         5NFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=PX5fsa+NLlEhxRi+aqxfpfq2rBqxuYpYJn1Xz9V0AUY=;
        b=lOg271kIX0TrbYfFpkdWZrSQw2BcSiqhqvZovxz61dl/j4zzsCuP5j0/GdbkA4WwXN
         2Ves7mDL7IaU3oAgpFkW4VAl48ysDPl/xCzbVBMJKls/Ow9P/35Ch0Ls4+0VzIT+D4gE
         C+5DcIbx4M53328ho2zsuZY93W6PB9mPfIJ/esJC2KE8LZmkTIqZoVTc/aYbRDKYe7J6
         wx2ueQGspj/EzIPZGx6kwIgWO1fljZf7Onk56B9FX7T5TzM3Sd09Ml97wFPvbqlEVWPO
         Gt4H0pqUS6WDC+vcRRr0JuOesDbAcVi2Jh2TTdvw/aOF8MSyXT9tqa2E1ONX6OIYfPeh
         pnog==
X-Gm-Message-State: APjAAAXIxg4B+gL8zBbVasxMDrbIvyO9qN19iXB4LuS8U7Nb3qSOGyZH
        yku/CKPWhI0LcwcBp+rNN8cA7vUz
X-Google-Smtp-Source: APXvYqx2K4abtzVRJyfpMJh5uRTURxVFI48v08+DYkp1cXh8Ih0xu+ZnZwhVDJKgkM5rTPqJBzQAZw==
X-Received: by 2002:a5d:8b57:: with SMTP id c23mr1258095iot.101.1572461491519;
        Wed, 30 Oct 2019 11:51:31 -0700 (PDT)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:20e8:5c8d:7cc:dc82])
        by smtp.googlemail.com with ESMTPSA id d6sm65275iop.34.2019.10.30.11.51.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Oct 2019 11:51:30 -0700 (PDT)
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
From:   David Ahern <dsahern@gmail.com>
Subject: bpf: bug in bpf_xdp_adjust_head, 5.0.20 kernel
Message-ID: <d3eddad2-4243-6505-75d1-83ac41ac1b9c@gmail.com>
Date:   Wed, 30 Oct 2019 12:51:28 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I hit this BUG with the 5.0.20 kernel built from stable tree:

[13294.815096] BUG: unable to handle kernel NULL pointer dereference at
0000000000000046
[13294.823913] #PF error: [normal kernel read fault]
[13294.829206] PGD 0 P4D 0
[13294.832056] Oops: 0000 [#1] SMP PTI
[13294.835976] CPU: 6 PID: 0 Comm: swapper/6 Kdump: loaded Tainted: G
       OE     5.0.20 #1
[13294.845557] Hardware name: Dell Inc. PowerEdge R620/0KCKR5, BIOS
2.7.0 05/23/2018
[13294.853979] RIP: 0010:__memmove+0x3d/0x1a0
[13294.858580] Code: 89 f0 49 01 d0 49 39 f8 0f 8f 9f 00 00 00 66 66 90
66 66 90 48 81 fa a8 02 00 00 72 05 40 38 fe 74 3b 48 83 ea 20 48 83 ea
20 <4c> 8b 1e 4c 8b 56 08 4c 8b 4e 10 4c 8b 46 18 48 8d 76 20 4c 89 1f
[13294.879698] RSP: 0018:ffff88b3bf6c3d90 EFLAGS: 00010286
[13294.885589] RAX: 000000000000004a RBX: ffff88b3bf6c3e78 RCX:
0000000000000046
[13294.893621] RDX: ffff88b3056d203a RSI: 0000000000000046 RDI:
000000000000004a
[13294.901642] RBP: ffff88b3056d20c4 R08: ffff88b3056d20c0 R09:
ffff88b3056d209a
[13294.909670] R10: 00000000000000c6 R11: 0000000000000008 R12:
0000000000000004
[13294.917695] R13: ffffb758865d30f8 R14: 0000000000000002 R15:
0000000000000002
[13294.925724] FS:  0000000000000000(0000) GS:ffff88b3bf6c0000(0000)
knlGS:0000000000000000
[13294.934816] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[13294.941281] CR2: 0000000000000046 CR3: 000000042580e002 CR4:
00000000000626e0
[13294.949299] Call Trace:
[13294.952041]  <IRQ>
[13294.954315]  bpf_xdp_adjust_head+0x68/0x80
[13294.958963]  ? i40e_napi_poll+0xb49/0x1630 [i40e]
[13294.964262]  ? enqueue_task_fair+0x90/0x790
[13294.968968]  ? net_rx_action+0x13d/0x3b0


The driver is i40e and the packets have a vlan header (rx-vlan-offload
is disabled). The xdp program is removing the vlan header with:

        if (bpf_xdp_adjust_head(ctx, sizeof(*vhdr)))
                return XDP_PASS;

no other changes are made to the packet.

The bug does not happen with the 5.4 net-next kernel, so it has been
fixed somewhere along the way which suggests the 5.0 kernel is in need
of a backport. Does this ring a bell with anyone?

David
