Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 721E645D468
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 06:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346192AbhKYFsu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 00:48:50 -0500
Received: from mail-wr1-f51.google.com ([209.85.221.51]:43745 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244249AbhKYFqu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 00:46:50 -0500
Received: by mail-wr1-f51.google.com with SMTP id v11so8945329wrw.10
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 21:43:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=kfe3A4R8dXaAE3Li4IfhMQCHnxthwu1GIOm9E/5B9N0=;
        b=2fxY7S1l0Q5L8gtvzOoxavnynstlWfWP9ABX97RKu58bIB4+5qLLcSevXyYmvkIPJA
         9LrURJ/aPvHeZNksqWCiJxHnCIDIy6B83d5KMUGgFXJ+MbDg52sYsFX8LaPA/npEIO9b
         lq5CunNCq5+VIrdpgwpAfyxh173gEUkC9IVbF5ZkbmUVCMaUNghhYi2NWiGRWqW9AaXz
         X72Z9NAXV5nA0HctOFCcVdBV3PKAhJtXHJfJ+fjVV9GhNtCc8L1XGaANcNEjSFAA2HnR
         maecY+Y8/lKTpDiVBz7wJ6DmJOICjW1hB816DcIQFYQkflrytWLVQ7OxTzTBOMGrys1G
         YxMQ==
X-Gm-Message-State: AOAM531dtYrtcWSLJq7j665cI1xQjtHL3FDCSJTPYoMTMk78qEBcY/oj
        O46Z0TtKtGVMdP6qcIM4ZLc=
X-Google-Smtp-Source: ABdhPJyrx34h+Cd45cPVUV0SnUNxg/vqyBn1wEkBJkgp62cQ80nK/k83VzQwry2Hicp2rEiTQ/spfA==
X-Received: by 2002:adf:fd4c:: with SMTP id h12mr3825128wrs.429.1637819019130;
        Wed, 24 Nov 2021 21:43:39 -0800 (PST)
Received: from ?IPV6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id h18sm1962331wre.46.2021.11.24.21.43.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Nov 2021 21:43:38 -0800 (PST)
Message-ID: <5c27a7c0-54a0-0fab-4680-350fcc12ac49@kernel.org>
Date:   Thu, 25 Nov 2021 06:43:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH net-next 1/3] mctp: serial: cancel tx work on ldisc close
Content-Language: en-US
To:     Jeremy Kerr <jk@codeconstruct.com.au>, netdev@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matt Johnston <matt@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20211123125042.2564114-1-jk@codeconstruct.com.au>
 <20211123125042.2564114-2-jk@codeconstruct.com.au>
 <b3307219-db82-d519-63df-dc246e11b037@kernel.org>
 <e97b2d3ee72ba8eec5fbae81ce0757806bf25d69.camel@codeconstruct.com.au>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <e97b2d3ee72ba8eec5fbae81ce0757806bf25d69.camel@codeconstruct.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 24. 11. 21, 7:38, Jeremy Kerr wrote:
> On the ldisc side: is there any case where we'd get a write wakeup
> during (or after) the ->close()?

there should be no invocation of ldisc after close(). If there is, it's 
a bug as this is even documented:

  * @close: [TTY] ``void ()(struct tty_struct *tty)``
  *
  *      This function is called when the line discipline is being shutdown,
  *      either because the @tty is being closed or because the @tty is 
being
  *      changed to use a new line discipline. At the point of execution no
  *      further users will enter the ldisc code for this tty.
  *
  *      Can sleep.


Should be the same also for the "during" case.

regards,
-- 
js
