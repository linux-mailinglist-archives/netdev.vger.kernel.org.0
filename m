Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2181C3DB5A4
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 11:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238146AbhG3JGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 05:06:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230335AbhG3JGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 05:06:20 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F0EBC061765;
        Fri, 30 Jul 2021 02:06:15 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id k1so10297032plt.12;
        Fri, 30 Jul 2021 02:06:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Mw1aFNNIOpDd6NtZ8F40EUdFGaW5gJZPJaFX36P2GH4=;
        b=PDhCB3WiEMgvoVoN6RSvr91JVfbkdxrwkvEDMIF9wzT17E0CzubrymEuVPOlE3NOXN
         /8YACLQCPhk56eQzxEZ8WPwnoCBJCMN7Za/s2Qc+zun84neby2kck5aOfEATqEsFOjv4
         bY6gn+7RP2/VJCJ3b/Is1HGQMZz43jUOsLtcr0Rf67qfHpm5xmzm5jruRJriT9QIjK2r
         hr0r31VDMsfbop9DWXSF9lSkxTL5tf8EjGiufZDdbKnWkYA0ezlGEXuYiJD9EQy9iUtX
         n2ATYssATUEy0lzTmo0MTGdFs9u9+Nmsi9AvJGXN+HERe7iaUBpvt46rKMY25YasxSnf
         duKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Mw1aFNNIOpDd6NtZ8F40EUdFGaW5gJZPJaFX36P2GH4=;
        b=qAINuhKqvQbY4tZX8reobiv5P3N4jaXnY3NMtJZ6q32X7JlD7DOvUoTqzheqYrP2ti
         Ee7I3WcgD6txGfvEzK/3pu324+JZfdK8XlWm6qkeq/R0IWPTDMgJjn0HTXx7dsi5Nz3Z
         k3enIczScHh7O7O3HLw/Grgw04s/q4CHW1fIjg5O29t5veYUP7C0imuvR2LDjJAL9GGf
         4k6Ps0XSaA82xzv4j8AoVRCjcwHj5qLB9sx/DcwTXttZjTCBMHHAmU6dhy0PFRQbPPFR
         oqSzSfamFVXBfeG0UHLjOn8h1c0yRZDzofZlSVCNAesAV5UyT3DqDJkbllzgt5SGM6po
         B84w==
X-Gm-Message-State: AOAM5330Ldd1g2pQDncaBt9n7JGcZPGgj6VWjShvtYNQyCHIuB1OhXNQ
        g4MkuTTxlbCmihlTapF4ns//b2nb9Q0isoenJ2E=
X-Google-Smtp-Source: ABdhPJwMP6iBF4QEFfQd4ZEwB71ogfa04DRHUob13iYfVP9XXnAjEIO+neixEejSZo4OBjngk8pIMA==
X-Received: by 2002:a17:903:49:b029:12b:1c88:101b with SMTP id l9-20020a1709030049b029012b1c88101bmr1771853pla.30.1627635974881;
        Fri, 30 Jul 2021 02:06:14 -0700 (PDT)
Received: from [192.168.1.237] ([118.200.190.93])
        by smtp.gmail.com with ESMTPSA id a16sm1570122pfo.66.2021.07.30.02.06.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Jul 2021 02:06:14 -0700 (PDT)
Subject: Re: [PATCH v3 2/2] Bluetooth: fix inconsistent lock state in
 rfcomm_connect_ind
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        skhan@linuxfoundation.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel-mentees@lists.linuxfoundation.org
References: <20210721093832.78081-1-desmondcheongzx@gmail.com>
 <20210721093832.78081-3-desmondcheongzx@gmail.com>
 <06E57598-5723-459D-9CE3-4DD8D3145D86@holtmann.org>
From:   Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
Message-ID: <40f38642-faa9-8c63-4306-6477e272cfbe@gmail.com>
Date:   Fri, 30 Jul 2021 17:06:09 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <06E57598-5723-459D-9CE3-4DD8D3145D86@holtmann.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marcel,

On 30/7/21 3:53 am, Marcel Holtmann wrote:
> Hi Desmond,
> 
>> Commit fad003b6c8e3d ("Bluetooth: Fix inconsistent lock state with
>> RFCOMM") fixed a lockdep warning due to sk->sk_lock.slock being
>> acquired without disabling softirq while the lock is also used in
>> softirq context. This was done by disabling interrupts before calling
>> bh_lock_sock in rfcomm_sk_state_change.
>>
>> Later, this was changed in commit e6da0edc24ee ("Bluetooth: Acquire
>> sk_lock.slock without disabling interrupts") to disable softirqs
>> only.
>>
>> However, there is another instance of sk->sk_lock.slock being acquired
>> without disabling softirq in rfcomm_connect_ind. This patch fixes this
>> by disabling local bh before the call to bh_lock_sock.
> 
> back in the days, the packet processing was done in a tasklet, but these days it is done in a workqueue. So shouldn’t this be just converted into a lock_sock(). Am I missing something?
> 

Thanks for the info. I think you're right, I just didn't understand very 
much when I wrote this patch.

If I'm understanding correctly, it seems that both the bh_lock_sock in 
rfcomm_connect_ind, and spin_lock_bh in rfcomm_sk_state_change need to 
be changed to lock_sock, otherwise they don't provide any 
synchronization with other functions in RFCOMM that use lock_sock.

If that sounds correct I can prepare the patch for that.

Best wishes,
Desmond
