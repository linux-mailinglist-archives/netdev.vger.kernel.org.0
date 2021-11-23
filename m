Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1138459A82
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 04:31:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233192AbhKWDer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 22:34:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbhKWDer (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 22:34:47 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCF3CC061574;
        Mon, 22 Nov 2021 19:31:39 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id v23so15465618pjr.5;
        Mon, 22 Nov 2021 19:31:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=icOtuugrfzpgVtFsKDZNNx7UamHELVHx2dk5MoNq3vY=;
        b=PFaFbETSI3vuvUA5p/7QfyjOKucgA2mJg9yjcgSrY/w7t6T7WDcSsI2eEnPDAsRUWr
         adsLj/xIj6sGSNpI2dSag5d1MomItjou8eZklrxW0eU77AFp8pmhoj58dBuhPintiQL6
         nRaXlwF027su70rmtcp7sRFcqQ55h/ChzrB9N2a0bdE/WyHqu5BAtc7iUGyl9i/JH5Te
         OzlWoXcCKGhidmRkANmw0E666KGIZOoQItaUL2gD/RlMjga2VmmEIuZoJwaszoRaj//U
         jwpniX9iWE1ch+6z3WCGBjdabgFGuvVDIC1AbDauHzKEmlRsvVJTkV73a23oInArg3Bt
         z6Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=icOtuugrfzpgVtFsKDZNNx7UamHELVHx2dk5MoNq3vY=;
        b=30RE4w7D9HFF0NHavRu1fR3i8rJDbTrgxoMMLgr+vk7/RXDt3jQypn0PXedwD+nWV+
         eorg+xx+PNy1JxOG7FqbxKccNAfETtIbTUeaN49/jDXPD3gA3HVTI8O+5Uhwnp6RJ4XR
         oKnc09HIq38qWGpuiit91s+krj/H7wk275KHi2tX333UCi4bI4VATgsJruQFM2iPxjCp
         YBxJbZTKA6kb1/6Jsa/ip+BnvnmPqh4/SwGqCzlOmz+mgCgXP+shO0fRIFIuxre+UXn0
         Ql7L/t35ANjxFk/haQN8yaJXl4+iWYiPEVq2AUDjN/vQIMsp0Yrx5Sq1H6neP9dIXrCY
         furg==
X-Gm-Message-State: AOAM530yzgKQQ6kvMzwNtOcNm8tGZUGvzqIGhPIfpCPxthirL3+RKlpl
        TScBl2kesy+lxQS5bxRPPaQ9JEDQz1k=
X-Google-Smtp-Source: ABdhPJyzf02Tv1mZ59ZW0L0QXYi/YYF9+L5BGzJ/b48/S63RIB/IYaIi6MIIHXUmgOo1rJOc0KyJrA==
X-Received: by 2002:a17:90b:30c4:: with SMTP id hi4mr2680047pjb.12.1637638298949;
        Mon, 22 Nov 2021 19:31:38 -0800 (PST)
Received: from [166.111.139.123] ([166.111.139.123])
        by smtp.gmail.com with ESMTPSA id e15sm9743430pfc.134.2021.11.22.19.31.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Nov 2021 19:31:38 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [BUG] marvell: mwifiex: two possible ABBA deadlocks
To:     amitkarwar@gmail.com, ganapathi017@gmail.com,
        sharvari.harisangam@nxp.com, huxinming820@gmail.com,
        kvalo@codeaurora.org, David Miller <davem@davemloft.net>,
        kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Message-ID: <0e495b14-efbb-e0da-37bd-af6bd677ee2c@gmail.com>
Date:   Tue, 23 Nov 2021 11:31:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

My static analysis tool reports two possible ABBA deadlocks in the 
mwifiex driver in Linux 5.10:

# DEADLOCK 1:
mwifiex_dequeue_tx_packet()
   spin_lock_bh(&priv->wmm.ra_list_spinlock); --> Line 1432 (Lock A)
   mwifiex_send_addba()
     spin_lock_bh(&priv->sta_list_spinlock); --> Line 608 (Lock B)

mwifiex_process_sta_tx_pause()
   spin_lock_bh(&priv->sta_list_spinlock); --> Line 398 (Lock B)
   mwifiex_update_ralist_tx_pause()
     spin_lock_bh(&priv->wmm.ra_list_spinlock); --> Line 941 (Lock A)

When mwifiex_dequeue_tx_packet() and mwifiex_process_sta_tx_pause() are 
concurrently executed, the deadlock can occur.

# DEADLOCK 2:
mwifiex_dequeue_tx_packet()
   spin_lock_bh(&priv->wmm.ra_list_spinlock); --> Line 1432 (Lock A)
   mwifiex_send_addba()
     spin_lock_bh(&priv->sta_list_spinlock); --> Line 608 (Lock B)

mwifiex_process_uap_tx_pause()
   spin_lock_bh(&priv->sta_list_spinlock); --> Line 363 (Lock B)
   mwifiex_update_ralist_tx_pause()
     spin_lock_bh(&priv->wmm.ra_list_spinlock); --> Line 941 (Lock A)

When mwifiex_dequeue_tx_packet() and mwifiex_process_uap_tx_pause() are 
concurrently executed, the deadlock can occur.

I am not quite sure whether these possible deadlocks are real and how to 
fix them if they are real.
Any feedback would be appreciated, thanks :)

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>


Best wishes,
Jia-Ju Bai
