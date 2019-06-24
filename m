Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F05451D5E
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 23:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729030AbfFXVuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 17:50:17 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36840 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726301AbfFXVuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 17:50:17 -0400
Received: by mail-pg1-f194.google.com with SMTP id f21so7817715pgi.3
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 14:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=/pHrwZdAlBHNYVcFFSyjX3jFKcJfHyjrohb7GcBvA/U=;
        b=HooAhlIEdgiCbJ3RvUUfA3oIfxjLLyCwJIW9yO8JRkq1HhU4a7478Ytb1B0gMO/86H
         fSvrAHHFeDAI7nCk9lIq1DbJO71dlUJ5zoaEsTF6C1Zgci0YAweaGXdX5ng7a+tbOUO+
         y9XO5t2y5iNLaa4cymPE3tmqR3RUnz/NXe/4P5iVg+ule+pKv1wndVOWOa/CI14TR//v
         uvLa7ydNxZIZrrWS5by/I7JVSrcYrFYzyeZ4K4cyscfg5PwRAWXCxRpZ/uY8g6sDJvkh
         Bb0cPBb6TWWAL1GioxWJ5TofOZjzmWhozxFo+eFetak+15JJH+MYXX0zNYV3uUbumZ7C
         SASg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=/pHrwZdAlBHNYVcFFSyjX3jFKcJfHyjrohb7GcBvA/U=;
        b=KDVXX8BqO9/RJiy73TWarqEb19WnZn/x77CaRWOQkbeuIL6K3CHpShEMDMBPs+ucD3
         Fkb6MpBM1xILf34LUs00Qe6GGHnAyK8L5lgbpTDLtQmHNgpofUA5u6OH5J1FAQCIXoLy
         4pLb/iusoBEXEyVgALzul8GfgFsYt907tljWhMj+OHEVhFbgnt8re4vny8X5SIAVLJzx
         pZJeuwlykZcDL0M4p52/IKpKVP3Wd7BmeFgfWiccbT+ejS/uWGk8yge8KdRcL759+PEV
         A2+72xkrQ5GQT8XLditTbvwoa9sq6rgFxpHlZ6JXNF8wmFXg5BXlq5cAipPUYplhIeuQ
         t8Sw==
X-Gm-Message-State: APjAAAXV1E0qoC2Zuq9oUc6f5hfdJLTN/OijPhxPgprJ2D9KzCxN5WiD
        g5NRSbEX2Pa9bGFwBDWq6uOp5QJDX4M=
X-Google-Smtp-Source: APXvYqwexWkQs7Lu5qpevR7p0uEOUNtzkMklhQDfnBnJRbOTlvErggQ0YGsrbSlmnGYxZQ9RTbwhzQ==
X-Received: by 2002:a65:42c4:: with SMTP id l4mr34869343pgp.436.1561413016141;
        Mon, 24 Jun 2019 14:50:16 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id 30sm491367pjk.17.2019.06.24.14.50.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 14:50:15 -0700 (PDT)
Subject: Re: [PATCH net-next 02/18] ionic: Add hardware init and device
 commands
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
References: <20190620202424.23215-1-snelson@pensando.io>
 <20190620202424.23215-3-snelson@pensando.io> <20190620215430.GK31306@lunn.ch>
 <65461426-92d8-cd87-942d-1fd82bd64fe4@pensando.io>
 <20190624131304.78c1a4a9@cakuba.netronome.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <8426e1db-6542-a67b-fc89-4d83eabdd807@pensando.io>
Date:   Mon, 24 Jun 2019 14:50:14 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190624131304.78c1a4a9@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/24/19 1:13 PM, Jakub Kicinski wrote:
> On Fri, 21 Jun 2019 15:22:22 -0700, Shannon Nelson wrote:
>>>> +static int identity_show(struct seq_file *seq, void *v)
>>>> +{
>>>> +	struct ionic *ionic = seq->private;
>>>> +	struct identity *ident = &ionic->ident;
>>>> +	struct ionic_dev *idev = &ionic->idev;
>>>> +
>>>> +	seq_printf(seq, "asic_type:        0x%x\n", idev->dev_info.asic_type);
>>>> +	seq_printf(seq, "asic_rev:         0x%x\n", idev->dev_info.asic_rev);
>>>> +	seq_printf(seq, "serial_num:       %s\n", idev->dev_info.serial_num);
>>>> +	seq_printf(seq, "fw_version:       %s\n", idev->dev_info.fw_version);
>>>> +	seq_printf(seq, "fw_status:        0x%x\n",
>>>> +		   ioread8(&idev->dev_info_regs->fw_status));
>>>> +	seq_printf(seq, "fw_heartbeat:     0x%x\n",
>>>> +		   ioread32(&idev->dev_info_regs->fw_heartbeat));
>>> devlink just gained a much more flexible version of ethtool -i. Please
>>> remove all this and use that.
>> Yes, we intend to add a devlink interface, it just isn't in this first
>> patchset, which is already plenty big.
> Please take this out of your patch set, we can't be expected to merge
> debugfs implementation of what has proper APIs :/
Got it.
sln

