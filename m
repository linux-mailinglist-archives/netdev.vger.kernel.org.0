Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE72E9261
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 22:50:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729904AbfJ2Vul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 17:50:41 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:42211 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729848AbfJ2Vuk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 17:50:40 -0400
Received: by mail-lj1-f194.google.com with SMTP id a21so289133ljh.9
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 14:50:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5w42mSO+u7mTiYLrDKEQn5Iqp5s1P00zLfBBlqGFSko=;
        b=b6r4WuTXHsg+po0/kmbiwEwcvN069ujoT/d2kPcxjVcYxpS41vdV6H6yGj/rXDnn3I
         bPfQoCkuLJ8TlIHxOFHOEGlFrMyfrTClTWqvR+am5SHjMkgrrrC5ylkOzJMTer+HfPP4
         oSOPRLAN82jlL1Z6kvjmK8QeoJuipufr8zkrs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5w42mSO+u7mTiYLrDKEQn5Iqp5s1P00zLfBBlqGFSko=;
        b=rXkJ/u3pMTwXSFcrm6f2mEXkZtv9uwicIwo2XczO0Qz5lrBUp9m3Kv9CfeFBpOB33R
         VH2MmkLPH4eKP7v4tb4dodtm1qSaZT0bEPqBdrR3yHo2fUAqy5mEc3XvqF/qJG39DQF0
         c7weH1to7LLxIMO3vkow2kYOuBj8g7Xxabf3SspBnX7v6BZiI9wdfPEmR7q/4m+Ikn8O
         4HlPg3SrQa9pwDfmdTqvWJjlVJLC5cbQjcsDxWCiN0d9Tcj0QwlSuZ9WMn+8SF8aQuWZ
         6e06oC/zcO8xtfymJnFrBLe6cwR53/7xIS/qiPnisjOUmw2yEGdqqO6cdMjNv54EngtI
         0Efw==
X-Gm-Message-State: APjAAAXmPfMGc+Ex2jZWouoSnKcEAGw2Tms2YZoqFGi08j5Op45ySB6a
        87IdkULChfeSit9XmY5K3P3srA==
X-Google-Smtp-Source: APXvYqyyipjjIhwC3Q2wW3zXN6CCYJ5yZ4W7qyXvacAjcmwrj1Sqwp5OqUTBOD7JRvKilDxiiFf/kw==
X-Received: by 2002:a2e:1bd5:: with SMTP id c82mr3718419ljf.207.1572385836669;
        Tue, 29 Oct 2019 14:50:36 -0700 (PDT)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id r18sm38411ljg.32.2019.10.29.14.50.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Oct 2019 14:50:35 -0700 (PDT)
Subject: Re: [PATCH net-next v2 4/4] bonding: balance ICMP echoes in layer3+4
 mode
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Matteo Croce <mcroce@redhat.com>, netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Paul Blakey <paulb@mellanox.com>, linux-kernel@vger.kernel.org
References: <20191029135053.10055-1-mcroce@redhat.com>
 <20191029135053.10055-5-mcroce@redhat.com>
 <5be14e4e-807f-486d-d11a-3113901e72fe@cumulusnetworks.com>
 <576a4a96-861b-6a86-b059-6621a22d191c@gmail.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <afdfd237-124d-0050-606f-cb5516c9e4d8@cumulusnetworks.com>
Date:   Tue, 29 Oct 2019 23:50:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <576a4a96-861b-6a86-b059-6621a22d191c@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/10/2019 23:03, Eric Dumazet wrote:
> 
> 
> On 10/29/19 11:35 AM, Nikolay Aleksandrov wrote:
> 
>> Hi Matteo,
>> Wouldn't it be more useful and simpler to use some field to choose the slave (override the hash
>> completely) in a deterministic way from user-space ?
>> For example the mark can be interpreted as a slave id in the bonding (should be
>> optional, to avoid breaking existing setups). ping already supports -m and
>> anything else can set it, this way it can be used to do monitoring for a specific
>> slave with any protocol and would be a much simpler change.
>> User-space can then implement any logic for the monitoring case and as a minor bonus
>> can monitor the slaves in parallel. And the opposite as well - if people don't want
>> these balanced for some reason, they wouldn't enable it.
>>
> 
> I kind of agree giving user more control. But I do not believe we need to use the mark
> (this might be already used by other layers)
> 
> TCP uses sk->sk_hash to feed skb->hash.
> 
> Anything using skb_set_owner_w() is also using sk->sk_hash if set.
> 
> So presumably we could add a generic SO_TXHASH socket option to let user space
> read/set this field.
> 

Right, I was just giving it as an example. Your suggestion sounds much better and
wouldn't interfere with other layers, plus we already use skb->hash in bond_xmit_hash()
and skb_set_owner_w() sets l4_hash if txhash is present which is perfect.

One thing - how do we deal with sk_rethink_txhash() ? I guess we'll need some way to
signal that the user specified the txhash and it is not to be recomputed ?
That can also be used to avoid the connect txhash set as well if SO_TXHASH was set prior
to the connect. It's quite late here, I'll look into it more tomorrow. :)

Thanks,
 Nik





