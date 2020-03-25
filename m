Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE65192BFE
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 16:14:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727612AbgCYPOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 11:14:23 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:34789 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727319AbgCYPOX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 11:14:23 -0400
Received: by mail-pj1-f68.google.com with SMTP id q16so2366406pje.1
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 08:14:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2RosR+wYvVXS+NXrvmDFIDR4zEn1PbZzz1YqeuOqXno=;
        b=RNqHEo0LIsZQxHZ+r7lSJ2VX/KEFTqg85tnAa8fXb0SeEyZH6RqCWU7Ov8IpeqW4J5
         lqmPe6CsbuAhQSNjgY4DDAQSi1YVWEga8fUQ5J37gVTfqMvLUy/fshZ4gYRu77P+HNW9
         Es3BDCzeObhcQZ4frKXCtJPrAzrH23fJorfamZ2lSNVfl6gOwkmqaQckgZbiLfbvBQtW
         REJWEBPh/c+iCQHe+lNH5QkyILWPaevnWDqn+Yx4x/EAAIVq+IhPTLqBTP66GLbL/8WH
         BaZwxOTaABcd+uaDrieIrq1BpmeEdOBR0L2iqjh7s8gY1KNCB5KzoBKKG8aB6oDJHYSn
         Tdeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2RosR+wYvVXS+NXrvmDFIDR4zEn1PbZzz1YqeuOqXno=;
        b=LbAK0auUH/ohXaLdhJaO5SFI/0T+wq2fyAO/563jXqPM2a277lqSC41s9SysS38790
         LjtEtsS6e77EdqH8XOluBtbAilJctrPymKGiyX/KCYfJF4VCmU+oSI940qtMTAKRdaII
         QSGSXS58taCE8y0ApDwpS/yZ2jbj5ce/5nLx6xh5jm5PfyFCHTr90wwT3LfI0vx4GV+X
         xqu2+ILDtoYk5vvoC2QL5aeHAbek4McrterdNiyh/EWf4k0CyHj559bqUZg540DefHou
         szVuLg+e4wHjYI/pBTaBwiqYG3okAmxG3JoP//Mj4pnS3FRBS5AJcKxd6WFdLqw7YaZX
         IXfw==
X-Gm-Message-State: ANhLgQ3gglhZCRUdeH6EVGI3kxSg89qFxmeRQlo9nrljoir7cJOzVZEN
        eYOZG6KoVAY6C2MkIhF4nMch2ZhG
X-Google-Smtp-Source: ADFU+vtdapIjBwqBM8xEQVS+/YekyG/MfifO8wMFYhcT+UNfrMGEqdOLyr7OY0Hbz203PGhnfIdEwQ==
X-Received: by 2002:a17:902:904c:: with SMTP id w12mr3552159plz.338.1585149261733;
        Wed, 25 Mar 2020 08:14:21 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id t186sm6587819pgd.43.2020.03.25.08.14.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Mar 2020 08:14:20 -0700 (PDT)
Subject: Re: [PATCH net-next] net: use indirect call wrappers for
 skb_copy_datagram_iter()
To:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>
References: <20200325022321.21944-1-edumazet@google.com>
 <ace8e72488fbf2473efaed9fc0680886897939ab.camel@redhat.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <c56fe143-9229-59a4-1bbd-ab08bf496dcb@gmail.com>
Date:   Wed, 25 Mar 2020 08:14:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <ace8e72488fbf2473efaed9fc0680886897939ab.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/25/20 4:52 AM, Paolo Abeni wrote:

> 
> I wondered if we could add a second argument for
> 'csum_and_copy_to_iter', but I guess that is a slower path anyway and
> more datapoint would be needed. The patch LGTM, thanks!

Yes, TCP would not need the csum stuff, I suspect the only users
of csum would avoid one indirect call per system call at most,
that is pure noise.

While TCP right now can trigger 45 indirect calls per skb copied to user space,
assuming standard 1500 bytes MTU.

> 
> Acked-by: Paolo Abeni <pabeni@redhat.com>

Thanks !

