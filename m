Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABBBF72298
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 00:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389587AbfGWWuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 18:50:25 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:36463 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732011AbfGWWuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 18:50:25 -0400
Received: by mail-pl1-f193.google.com with SMTP id k8so21179092plt.3
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 15:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=tB2KEWlYpFtTO3TmZHKto0i9xLmODXDtd3gSEi6RTJs=;
        b=jEO2otdExDp78O9NecovedOoFFPCYricDEARrMyIv87QVQmROqIYbVRbVBljNkelfJ
         Z4PyZxnWLVRg3pc99nfeSENuZGCOFAcb5gOVHj/kPE+NQ9HzvL2xZCVL6NfTU01Rn21B
         qSZiPQJ3C41PE94FDW4mYaqT0bPSiRenDu2voCW4ULgFVenkK5bTUjWZPCGGwbiEmKrV
         PLAB4DOzj1DfleNYpY46olKuV/LzJ6l7th9eg+dVLMkmEwn5A/7aJtqUTGke/BPqMkva
         yCroE2XgEmCk6+MM4tO/uPLhQZEx2HJO4eu4WeolxsgxW2AOoOqqy/h7kBS9TIqhd3Yn
         4trg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=tB2KEWlYpFtTO3TmZHKto0i9xLmODXDtd3gSEi6RTJs=;
        b=QDZsfmaNx6I43jjuCqaK7RVRmtwG6yd8Bfse6a0huZxRJjN1E9DM8AshE7/Z3yS9gH
         Hg40jW/jUGB6tCU03L8ak4Vbjj0y1zCtYK2Ny9THubOAwYJb6kxUYFH8uAxpmq+RRp94
         rxp85pOdvn1Mq8k2P+0Cv1TolcuYsZY4m+ChQWx9kCHfMQZAJnFJvvWu3+C1ItEtJLZ7
         GP+WqLztsdjt3RXvg02uW6Pj61KUA0E25I8QtLrwLTCJRfI6STwZDAniPnCGmX83pDQu
         IHiMg9JXf0sRybfevp5PZ93OTaxU26wJWYdhUp6tQgm85vsMv674zDPAIKmPnXaVmBwD
         K62A==
X-Gm-Message-State: APjAAAWVw+yQ7EAb6X/Kvtuae0BL5f9M0N0aa9gDFO5sgjKICJRneBaO
        U+GdVAZNmsxRsTZ47qreN5lOSjE8/Td4Tw==
X-Google-Smtp-Source: APXvYqx4dZgs5Qx62SDyO2M6B8qdJd1fEdGK3Qh2obHc1pVbzSBEEZHnixbueUPs0X2g5sVjeGJ9MQ==
X-Received: by 2002:a17:902:d715:: with SMTP id w21mr43840450ply.261.1563922224792;
        Tue, 23 Jul 2019 15:50:24 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id q69sm62068455pjb.0.2019.07.23.15.50.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Jul 2019 15:50:24 -0700 (PDT)
Subject: Re: [PATCH v4 net-next 02/19] ionic: Add hardware init and device
 commands
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
References: <20190722214023.9513-1-snelson@pensando.io>
 <20190722214023.9513-3-snelson@pensando.io>
 <20190723.141833.384334163321137202.davem@davemloft.net>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <59e45fd2-3c62-58cf-cf63-935d17703d2c@pensando.io>
Date:   Tue, 23 Jul 2019 15:50:22 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190723.141833.384334163321137202.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/23/19 2:18 PM, David Miller wrote:
> From: Shannon Nelson <snelson@pensando.io>
> Date: Mon, 22 Jul 2019 14:40:06 -0700
>
>> +void ionic_init_devinfo(struct ionic_dev *idev)
>> +{
>> +	idev->dev_info.asic_type = ioread8(&idev->dev_info_regs->asic_type);
>> +	idev->dev_info.asic_rev = ioread8(&idev->dev_info_regs->asic_rev);
>> +
>> +	memcpy_fromio(idev->dev_info.fw_version,
>> +		      idev->dev_info_regs->fw_version,
>> +		      IONIC_DEVINFO_FWVERS_BUFLEN);
>> +
>> +	memcpy_fromio(idev->dev_info.serial_num,
>> +		      idev->dev_info_regs->serial_num,
>> +		      IONIC_DEVINFO_SERIAL_BUFLEN);
>   ...
>> +	sig = ioread32(&idev->dev_info_regs->signature);
> I think if you are going to use the io{read,write}{8,16,32,64}()
> interfaces then you should use io{read,write}{8,16,32,64}_rep()
> instead of memcpy_{to,from}io().
>
Sure.
sln

