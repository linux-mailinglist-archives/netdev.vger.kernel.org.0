Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99D5E3FF5BF
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 23:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347515AbhIBVmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 17:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347065AbhIBVmX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 17:42:23 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6734C061575;
        Thu,  2 Sep 2021 14:41:24 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id q21so2051763plq.3;
        Thu, 02 Sep 2021 14:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gKhofwX8eKC2JSzzcueboqtoVn6s6titp85hWLz+MiE=;
        b=G773dK+zb9KFXL4NJcyHC2QEe0pQ9cj7+RuS5DYcXBZz3tmormwCFE1FYY98IMLQwe
         HEO6OL4EzaTU0QhhMqjqcVPwnWc92CRJV4Sq9kecqycHsc+g+RI4T8jc71NXHQ7gd+A/
         Ztp3aPFnZFBGTaPlwAounXVsZdaZs40Kp+3yGC1frnipHYZ0QBO41Ffd72BqCAuP1453
         nlfPLy9vHTjXq/PuKQQRuTTXEzzfBN+2GPV75vHXU2k6cssxMM5ejUdGcoj41AM/ZbLd
         qQ1K8AlNXmA5xWwNFvSsCd+fMl82ByXxurKhQTNHm6q0XyLNY0Ol9+eanw1EEnUDapSk
         Uhdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gKhofwX8eKC2JSzzcueboqtoVn6s6titp85hWLz+MiE=;
        b=EY6zKtbG+zXOBn4aAT6zZGCktF7MlhtO9XLwao+ZMB8OJ/N9SErOYcVt5W2cpnP4Vk
         bFGtwIInbZ9gfF+LX+suO2xhAsVawS+H3ZLCHgh1eZARRiW+nyqmPeaBgvoFcS7KmbqV
         KQp3/L66162AuXeYhQm7hXsxVaeuoQVoAaYOd6xe1X0BmBoNghL4NCtP85lrxXuYD7Yk
         yOZQ3/VK5McYnOTsIiIg+E6sCLGCFLllOFUmn4hoGiquxAEn+gkPkR4VnEjXaUl+IFEd
         RJPMLMlP1lsBwrb1/rEItW5uPOe8Givb4f33nSl9+ModekSB7TwXeX/7TidRYOwhBffb
         rEEQ==
X-Gm-Message-State: AOAM530cagNnqtpKNzd4pIxfc9iqhpRJKc4I0BgsB+8hGZtM4JXtvqzX
        aq8K9PxR9nvrotDJgCHU0UY=
X-Google-Smtp-Source: ABdhPJzzmNZElA2KFyxko6m3d3UVnrhycp3ie/k0k26k+VXUUDE4Hd35nD0F+eyazlnCiqG9F4Yd6Q==
X-Received: by 2002:a17:90a:5511:: with SMTP id b17mr222194pji.222.1630618884160;
        Thu, 02 Sep 2021 14:41:24 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id n185sm3497124pfn.171.2021.09.02.14.41.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Sep 2021 14:41:23 -0700 (PDT)
Subject: Re: [PATCH v6 1/6] Bluetooth: schedule SCO timeouts with delayed_work
To:     Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com, davem@davemloft.net,
        kuba@kernel.org, sudipm.mukherjee@gmail.com
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, skhan@linuxfoundation.org,
        gregkh@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+2f6d7c28bb4bf7e82060@syzkaller.appspotmail.com
References: <20210810041410.142035-1-desmondcheongzx@gmail.com>
 <20210810041410.142035-2-desmondcheongzx@gmail.com>
 <0b33a7fe-4da0-058c-cff3-16bb5cfe8f45@gmail.com>
 <bad67d05-366b-bebe-cbdb-6555386497de@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <94942257-927c-efbc-b3fd-44cc097ad71f@gmail.com>
Date:   Thu, 2 Sep 2021 14:41:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <bad67d05-366b-bebe-cbdb-6555386497de@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/2/21 12:32 PM, Desmond Cheong Zhi Xi wrote:
> 
> Hi Eric,
> 
> This actually seems to be a pre-existing error in sco_sock_connect that we now hit in sco_sock_timeout.
> 
> Any thoughts on the following patch to address the problem?
> 
> Link: https://lore.kernel.org/lkml/20210831065601.101185-1-desmondcheongzx@gmail.com/


syzbot is still working on finding a repro, this is obviously not trivial,
because this is a race window.

I think this can happen even with a single SCO connection.

This might be triggered more easily forcing a delay in sco_sock_timeout()

diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index 98a88158651281c9f75c4e0371044251e976e7ef..71ebe0243fab106c676c308724fe3a3f92a62cbd 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -84,8 +84,14 @@ static void sco_sock_timeout(struct work_struct *work)
 
        sco_conn_lock(conn);
        sk = conn->sk;
-       if (sk)
+       if (sk) {
+               // lets pretend cpu has been busy (in interrupts) for 100ms
+               int i;
+               for (i=0;i<100000;i++)
+                       udelay(1);
+
                sock_hold(sk);
+       }
        sco_conn_unlock(conn);
 
        if (!sk)


Stack trace tells us that sco_sock_timeout() is running after last reference
on socket has been released.

__refcount_add include/linux/refcount.h:199 [inline]
 __refcount_inc include/linux/refcount.h:250 [inline]
 refcount_inc include/linux/refcount.h:267 [inline]
 sock_hold include/net/sock.h:702 [inline]
 sco_sock_timeout+0x216/0x290 net/bluetooth/sco.c:88
 process_one_work+0x98d/0x1630 kernel/workqueue.c:2276
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2422
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

This is why I suggested to delay sock_put() to make sure this can not happen.

diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index 98a88158651281c9f75c4e0371044251e976e7ef..bd0222e3f05a6bcb40cffe8405c9dfff98d7afde 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -195,10 +195,11 @@ static void sco_conn_del(struct hci_conn *hcon, int err)
                sco_sock_clear_timer(sk);
                sco_chan_del(sk, err);
                release_sock(sk);
-               sock_put(sk);
 
                /* Ensure no more work items will run before freeing conn. */
                cancel_delayed_work_sync(&conn->timeout_work);
+
+               sock_put(sk);
        }
 
        hcon->sco_data = NULL;
