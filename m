Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49E641E1AA4
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 07:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbgEZFQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 01:16:44 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34285 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgEZFQo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 01:16:44 -0400
Received: by mail-wr1-f66.google.com with SMTP id r7so2394874wro.1
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 22:16:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=nJy5Y/wFhqFBhHT59jrIgHaVUD/qjpVN0AKUN1fDJdQ=;
        b=gn54ZT7jhQUZ6gEUdUZh9eup5NydKVSRpRNYsHv9Y1a+gi6nOql4t+5+9zqNJYYxjX
         ojkAJ+FxSILxnbXSODRzSgdAtwYy2FzKDJeZQ+bpRIZfiHa8TDEAwRvaOtFPMn8+zeoB
         vU7hrAQ2ebdw+t/H/rEBoUWxSFGM4ezR+s1SSP77XSB9r8ay8vznh391hQcYQLEJIt0F
         n1dk6CvZjk3JRvAlDJ0D0hp8FzjQV9xa1/cjFi1ldj7IlzFKx2hy2C50SC/hug05erg6
         eRDuZAcjcm0p95Jrbi255QKDzX8j698qXrlZ4GsysvVwxPNqEUB+kr358yT96aIh34q2
         QGdA==
X-Gm-Message-State: AOAM533zWp5mhEaYVSpmOagIs1seHWwW0VnxWx5W4hk894Imol+4EpLr
        NVxJuBQdk3MHuGQWTTnVgdU=
X-Google-Smtp-Source: ABdhPJyMfKMei90bNH0yaIwELtH0DBWlPHSWNTMq2PHBi0nVjke+rsl1XhE4AKvnQFOJ7r2hpXI9PA==
X-Received: by 2002:adf:e450:: with SMTP id t16mr19495513wrm.66.1590470202261;
        Mon, 25 May 2020 22:16:42 -0700 (PDT)
Received: from ?IPv6:2a02:21b0:9002:414a:5d95:b3ad:52db:6030? ([2a02:21b0:9002:414a:5d95:b3ad:52db:6030])
        by smtp.gmail.com with ESMTPSA id 23sm12321010wmo.18.2020.05.25.22.16.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 May 2020 22:16:41 -0700 (PDT)
Reply-To: valentin@longchamp.me
Subject: Re: [PATCH] net/ethernet/freescale: rework quiesce/activate for
 ucc_geth
To:     David Miller <davem@davemloft.net>
Cc:     linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        kuba@kernel.org, hkallweit1@gmail.com, matteo.ghidoni@ch.abb.com
References: <20200520155350.1372-1-valentin@longchamp.me>
 <20200522.155054.352367636201826991.davem@davemloft.net>
From:   Valentin Longchamp <valentin@longchamp.me>
Message-ID: <aa59c21d-c15a-b087-cc17-04535ebcdb41@longchamp.me>
Date:   Tue, 26 May 2020 07:16:45 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200522.155054.352367636201826991.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 23.05.2020 à 00:50, David Miller a écrit :
> From: Valentin Longchamp <valentin@longchamp.me>
> Date: Wed, 20 May 2020 17:53:50 +0200
> 
>> ugeth_quiesce/activate are used to halt the controller when there is a
>> link change that requires to reconfigure the mac.
>>
>> The previous implementation called netif_device_detach(). This however
>> causes the initial activation of the netdevice to fail precisely because
>> it's detached. For details, see [1].
>>
>> A possible workaround was the revert of commit
>> net: linkwatch: add check for netdevice being present to linkwatch_do_dev
>> However, the check introduced in the above commit is correct and shall be
>> kept.
>>
>> The netif_device_detach() is thus replaced with
>> netif_tx_stop_all_queues() that prevents any tranmission. This allows to
>> perform mac config change required by the link change, without detaching
>> the corresponding netdevice and thus not preventing its initial
>> activation.
>>
>> [1] https://lists.openwall.net/netdev/2020/01/08/201
>>
>> Signed-off-by: Valentin Longchamp <valentin@longchamp.me>
>> Acked-by: Matteo Ghidoni <matteo.ghidoni@ch.abb.com>
> 
> Applied, thanks.
> 

Thanks David.

May I suggest that this get backported to stable until (including) the 
4.19 stable release ?

As the above mentioned commit, merged for 4.19,
124eee3f6955 net: linkwatch: add check for netdevice being present to 
linkwatch_do_dev
does indeed break the ucc_geth driver, this patch can be considered as a 
bugfix that should be taken into account for stable.
