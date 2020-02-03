Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5F41512A2
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 00:01:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbgBCXBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 18:01:46 -0500
Received: from mail-wm1-f45.google.com ([209.85.128.45]:33759 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726561AbgBCXBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 18:01:46 -0500
Received: by mail-wm1-f45.google.com with SMTP id m10so906761wmc.0
        for <netdev@vger.kernel.org>; Mon, 03 Feb 2020 15:01:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=L/WmTifwmb89BwczOAGZOKM4jEn1McfbNHT4zsZzsqk=;
        b=b6Z1NPOc90KxyfZxvIPq9oTI2wC8S/JW90xYYYcMS71Mdy3OzAhwbnSfnAlk/z86oD
         zc2r5R4V8AKTzLjMO83EaNF8qhL/8OZRbFFI3JThsyZawtdQLRkSDtr5MnoGYZ7sEn9o
         0zKVeJA5fPdEab2H+yCceY9mLj821RrP/1eYU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=L/WmTifwmb89BwczOAGZOKM4jEn1McfbNHT4zsZzsqk=;
        b=WcuoqZuB12g8El8Nw218eBjYUSnFm/SQnk0NgKXixzlJshBuzwq0XTt3v8qrd47Jrx
         n6CIkuvYM5a/0/gwtBCpMoJ38jrTC1WA7x4Rb1FshUFWIA+b/9TFNgX2Nx3WJkKdrtVb
         ldg9NenRafkGrpI/Zucd35vvFgAiODkriUcz1tkSqbRHrv6iWUHHfDBzZyV4kUkpGFDC
         BrRc83ODa4yoNFDKIj7CyxmB01FskZVE/SfTaGtbvh4UwEfygBj3NMmwmWuGghcNtijv
         259yyj1RWv8sJ3wbRup3TQw3r4Rc75ZOBCVvBtnE/wuJ5WeUgSY6qgyhhh80ZYaUqvgf
         UP7Q==
X-Gm-Message-State: APjAAAVCIjHLMZEMqkdNqPA9c9vTrrx9bQpjVa9cnM1iqRWtSjsexydI
        eCO9DyVQT4PQOZnnzDsV3krrpA==
X-Google-Smtp-Source: APXvYqxKfIyAwPGFZH6hhinfmnaMBYKvz9zPEaOcLLhtZP7NlDgbeDOcVLjNgEIJc2REVbq+ryMVzg==
X-Received: by 2002:a1c:6308:: with SMTP id x8mr1371643wmb.80.1580770902705;
        Mon, 03 Feb 2020 15:01:42 -0800 (PST)
Received: from rj-aorus.ric.broadcom.com ([192.19.228.250])
        by smtp.gmail.com with ESMTPSA id c15sm26990390wrt.1.2020.02.03.15.01.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Feb 2020 15:01:41 -0800 (PST)
To:     Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ray Jui <ray.jui@broadcom.com>,
        BCM Kernel Feedback <bcm-kernel-feedback-list@broadcom.com>
From:   Ray Jui <ray.jui@broadcom.com>
Subject: RFC: Use of devlink/health report for non-Ethernet devices
Message-ID: <f8e67e40-71d4-f03c-6bc0-6496663af895@broadcom.com>
Date:   Mon, 3 Feb 2020 15:01:37 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiri/Eran/David,

I've been investigating the health report feature of devlink, and have a 
couple related questions as follows:

1. Based on my investigation, it seems that devlink health report 
mechanism provides the hook for a device driver to report errors, dump 
debug information, trigger object dump, initiate self-recovery, and etc. 
The current users of health report are all Ethernet based drivers. 
However, it does not seem the health report framework prohibits the use 
from any non-Ethernet based device drivers. Is my understanding correct?

2. Following my first question, in this case, do you think it makes any 
sense to use devlink health report as a generic error reporting and 
recovery mechanism, for other devices, e.g., NVMe and Virt I/O?

3. In the Ethernet device driver based use case, if one has a "smart 
NIC" type of platform, i.e., running Linux on the embedded processor of 
the NIC, it seems to make a lot of sense to also use devlink health 
report to deal with other non-Ethernet specific errors, originated from 
the embedded Linux (or any other OSes). The front-end driver that 
registers various health reporters will still be an Ethernet based 
device driver, running on the host server system. Does this make sense 
to you?

Thanks in advance for your feedback!

Thanks,

Ray


