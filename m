Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD4245755
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 10:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbfFNIU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 04:20:28 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43909 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725907AbfFNIU1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 04:20:27 -0400
Received: by mail-pf1-f193.google.com with SMTP id i189so965283pfg.10;
        Fri, 14 Jun 2019 01:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W5nhBd4tGkI+YkG/MObiCYrxBxL/ZsCas4j/NPHh32A=;
        b=rl0+BwINzNssk0x2Yex1Dc3r/f07cgA/+mjq6AUfkshnGmdLRua9K0rP0OrGm1+uZC
         QDQdcVGhjIh70mpECzlM9WpVjc66S4qNh5ncfXVrc3/8EmJENNMzB9v3l7Wx4ZyFIQQs
         ZcqY1nC0NdEY9v8+ej+UcNTrxHLQAmWEQLXH/8P+wkYcldsA2GPFukAQRj6ikm2PWr7q
         2IhoJXa21q4orCEF8yeWaHEfZIdURDVNdIvAp7HLjdKjGeQ7b0WNHu7S2xGCGBYEo7Vk
         LDTErnW8T3TwwolIljagF+qtP1VCeZlAt9CaGVMSpSJ7k/5gcuhHNW2vJY+oOlWaFyJo
         BuoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W5nhBd4tGkI+YkG/MObiCYrxBxL/ZsCas4j/NPHh32A=;
        b=PcD/7OW6KYWmo5rys2P8YDX2d/RCXhguT07Ju1EGYq6AJc+UdkLqrfXlGLKJ35tEbJ
         w7OyTBh8G5NiMZA1sk0H5gBe0gXdsBw9mQBcAL03fvj5RA1vjD0WlT2/7joAqozudIH1
         oz3VXrzjFNkfNJJJSFWr/6pwiXUSmgiYB3cudZkAZaXE1YOH/cybxa4YnVk5OhTrXg1g
         zD6t3lG28VI9N42zH2zHr2GUqVxunmaaY4ByiP9DW6cwbrxkZCKfjVsjPlHlxmGCA1Z9
         r5edV0pI9zGclTpDFo/MfCfzUmzw9IrowZ/x34mdcL/yKz+3ZQOEfeti9NvBM8dtcvRF
         aLXQ==
X-Gm-Message-State: APjAAAXlXVpTx3mMMOUE1PNIXZP6QqIKRLHTFUNHKj2DJVQcNzntAZME
        oX7mKoGJTwnccYkYmZAAbLY=
X-Google-Smtp-Source: APXvYqyBCZ/QovHTeuxnultLakLrj5E8Uu7UuEYLK+KqX03zArrZ9vqsTwbfiM8/5nX8FEJ3SB5dLA==
X-Received: by 2002:a65:6096:: with SMTP id t22mr33979197pgu.71.1560500427047;
        Fri, 14 Jun 2019 01:20:27 -0700 (PDT)
Received: from z400-fedora29.kern.oss.ntt.co.jp ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id t18sm3352343pgm.69.2019.06.14.01.20.23
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 14 Jun 2019 01:20:26 -0700 (PDT)
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        netdev@vger.kernel.org, xdp-newbies@vger.kernel.org,
        bpf@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH bpf 0/3] Devmap fixes around memory and RCU
Date:   Fri, 14 Jun 2019 17:20:12 +0900
Message-Id: <20190614082015.23336-1-toshiaki.makita1@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch1: Jesper showed concerns around devmap free and flush race when
    reviewing my XDP bulk TX patch set, and I think indeed there is a
    race. Patch1 fix it.

Patch2: While reviewing dev_map_free I found bulk queue was not freed.
    Patch2 fix it.

Patch3: Some days ago David Ahern reported suspicous RCU usage in
    virtnet_xdp_xmit(), but it seems no one posted an official fix
    patch. So I arraged the fix.

Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>

Toshiaki Makita (3):
  devmap: Fix premature entry free on destroying map
  devmap: Add missing bulk queue free
  devmap: Add missing RCU read lock on flush

 kernel/bpf/devmap.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

-- 
1.8.3.1

