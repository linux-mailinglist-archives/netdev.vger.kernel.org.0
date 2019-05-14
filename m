Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10EEB1C910
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 14:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbfENMzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 08:55:41 -0400
Received: from mail-pf1-f172.google.com ([209.85.210.172]:38926 "EHLO
        mail-pf1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbfENMzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 08:55:41 -0400
Received: by mail-pf1-f172.google.com with SMTP id z26so9109731pfg.6;
        Tue, 14 May 2019 05:55:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=ivZhgPRsPy6zp/Syvj+/ZJXkxMnZ4T63yw6MhGlwYzE=;
        b=JN2Ml9ScBqjHNWc9zRtLejdGxae7BOkPMYS4IOIeUnoP3MW6aAhM5SBookEpMuPxtP
         wbV/8hox/6OqR0R3+Epm8UF9Vol7K7GOwFbsnhz799RrpMSErUcTifjUdEGHUCvVbdLO
         d53ZITZA+H7yEVOryslcCJ6u58RNdGDnceVTdKs0ntSBNyK3l0Mn1UXkzKiixx+SCuaj
         vEPQnATAIm9h/iugReWnJs6qNB8G4EAf8HWGSlvk5NJoosJeu78bdwe7UUXM79QZRpek
         1za2QAsF4xPOXf7M/a+2HuZFzRWrqG5PVDE3pFTJbT/jfWwJKaD8pY6f2oaEvpgB33gt
         LTKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=ivZhgPRsPy6zp/Syvj+/ZJXkxMnZ4T63yw6MhGlwYzE=;
        b=l/ysB74JhSVWs/Yim1ddifmS3HU9lwVtHukTQe1vADGVE2S4FhNsrdDq419WUSvbce
         QNjCJrwopOfYl4NcNDSuGwYTWFqcSsKyTQ+oYWicF9GQ5UKJ8e9Jx/god8d54u0P8x7e
         xkUHpoZKZut1sMkIUnfQN5CcMhNc2eFHvjatvotC8jPURDJOrm2n8I9HNMSt892YZfrp
         3TLzOZjD+074YZqwWJWZ2p6lLysw8ExQ4lrayVfAvHn1QLG6sK6l1bC5PcotCdyv9ZG1
         10HoQhUuATK1l/H3idQ1tG6/GhpADvMGfn6U4ORP9kg9atqVqhsVSm92zbh/gdtXzg11
         ZYxw==
X-Gm-Message-State: APjAAAUxxtPyuhJy5W6QyORPl8/Hgnkxn9rcHuRcGbrz9/YMkykHIlDd
        zGAuNHRP/+ujQptpvhIAlTJIE/aq
X-Google-Smtp-Source: APXvYqzNz4IDjwn58z8svv4G9wGQ2kABhyMAAlmhdQpO1zfYwpiDGDQdox4hI0aqvB2rMXuKVLKHLQ==
X-Received: by 2002:a62:e101:: with SMTP id q1mr40766334pfh.160.1557838540166;
        Tue, 14 May 2019 05:55:40 -0700 (PDT)
Received: from ?IPv6:2402:f000:1:1501:200:5efe:166.111.71.27? ([2402:f000:1:1501:200:5efe:a66f:471b])
        by smtp.gmail.com with ESMTPSA id 125sm9051773pge.45.2019.05.14.05.55.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 May 2019 05:55:39 -0700 (PDT)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [BUG] rtlwifi: Resource leaks in error handling code of
 rtl_pci_probe()
To:     pkshih@realtek.com, kvalo@codeaurora.org, davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <508009c2-6ebf-6c11-1f52-ef488c70ce32@gmail.com>
Date:   Tue, 14 May 2019 20:55:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In rtl_pci_probe(), rtl_pci_init() allocates some resources, such as:
_rtl_pci_init_trx_ring
   _rtl_pci_init_rx_ring
     _rtl_pci_init_rx_ring
       pci_zalloc_consistent() -- resource
       _rtl_pci_init_one_rxdesc
         dev_alloc_skb() -- resource

_rtl_pci_init_trx_ring
   _rtl_pci_init_tx_ring
     pci_zalloc_consistent() -- resource

When ieee80211_register_hw() or rtl_pci_intr_mode_decide() fails, these 
resources are not released in error handling code.

A possible fix is to call rtl_pci_deinit() in error handling code, but I 
am not sure whether this is correct.
Thus, I only report the bugs.

These bugs are found by a runtime fuzzing tool named FIZZER written by us.


Best wishes,
Jia-Ju Bai
