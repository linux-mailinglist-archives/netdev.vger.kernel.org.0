Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3AD6E9093
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 21:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727227AbfJ2UIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 16:08:05 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:39542 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727182AbfJ2UIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 16:08:05 -0400
Received: by mail-lj1-f196.google.com with SMTP id y3so41363ljj.6
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 13:08:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fW2Zh/fTxEZOQPa2raWuuwC2pp8Sz2KHBFNnTB4eWEs=;
        b=RUiChNT+/TnFFn5bjZwy2byqh22AKTbCJCBObmS8MMm0mlDFMZ3+ZUQvfEUKFxPfHG
         gKxqOXG9HM6Q9ws432DlC69CJ1HXXWAvsTZqvIDSOMrVjajWeWOgimDKr+6kQy+WHMTC
         b29b5ymq9R3f4xru5r7JFju+iQs56sx4I/u3o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fW2Zh/fTxEZOQPa2raWuuwC2pp8Sz2KHBFNnTB4eWEs=;
        b=tTrmybT3lhTFO92E6lOR66H+dc7hwyRcFaJggQarMu5JThElImKghDfxpi0tyznnKo
         g++5Z/Q5cZt1sP6ETEsCwzmJm/rMjlHzBSRP4DRz7fyfDC/ceFARLJTyO8HRvUXuuYY2
         PNn5lB2eSH3uvKumJcBZ+sHDKdIQ5RdK2kzekECi4y4z/lTNNHJSdcg7myEArFcTn2gz
         fc4oIqvLmAyhRUu54DpnOMeUbkOlQVUZYQo3LcdFa7tu1vJzsctGbZISHydgmUEciRNK
         sFazmhg3OMzc+TK/l6H+jb8Alm+6MlugJC+K4RWLLTCTu1nprWa/ePOBzjyArn0rWOh+
         QKwA==
X-Gm-Message-State: APjAAAWHMY83h+2TLegjuaUOhmwCJpTpX3FHUI0vi/9RZWW1j9GvPtgo
        x1JaLhoGFJCoXUrqc8Fv7VbwpQ==
X-Google-Smtp-Source: APXvYqzrxTfHZiXkL4r08L/mBr55DZk5LZ8cDufkeXKRww3LG076jKVtRPf00+Gs2EEPUjqjgwsFZQ==
X-Received: by 2002:a2e:8204:: with SMTP id w4mr3977803ljg.212.1572379683232;
        Tue, 29 Oct 2019 13:08:03 -0700 (PDT)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id w20sm9606082lff.46.2019.10.29.13.07.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Oct 2019 13:08:00 -0700 (PDT)
Subject: Re: [PATCH net-next v2 4/4] bonding: balance ICMP echoes in layer3+4
 mode
To:     Matteo Croce <mcroce@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Paul Blakey <paulb@mellanox.com>,
        LKML <linux-kernel@vger.kernel.org>
References: <20191029135053.10055-1-mcroce@redhat.com>
 <20191029135053.10055-5-mcroce@redhat.com>
 <5be14e4e-807f-486d-d11a-3113901e72fe@cumulusnetworks.com>
 <a7ef0f1b-e7f5-229c-3087-6eaed9652185@cumulusnetworks.com>
 <CAGnkfhwmPxFhhEawxgTp9qt_Uw=HiN3kDVk9f33mr7wEJyp1NA@mail.gmail.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <568200b1-fa27-6cb2-7586-d79829b24e4c@cumulusnetworks.com>
Date:   Tue, 29 Oct 2019 22:07:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <CAGnkfhwmPxFhhEawxgTp9qt_Uw=HiN3kDVk9f33mr7wEJyp1NA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/10/2019 21:45, Matteo Croce wrote:
> On Tue, Oct 29, 2019 at 7:41 PM Nikolay Aleksandrov
> <nikolay@cumulusnetworks.com> wrote:
>>
>> On 29/10/2019 20:35, Nikolay Aleksandrov wrote:
>>> Hi Matteo,
>>> Wouldn't it be more useful and simpler to use some field to choose the slave (override the hash
>>> completely) in a deterministic way from user-space ?
>>> For example the mark can be interpreted as a slave id in the bonding (should be
>>> optional, to avoid breaking existing setups). ping already supports -m and
>>> anything else can set it, this way it can be used to do monitoring for a specific
>>> slave with any protocol and would be a much simpler change.
>>> User-space can then implement any logic for the monitoring case and as a minor bonus
>>> can monitor the slaves in parallel. And the opposite as well - if people don't want
>>> these balanced for some reason, they wouldn't enable it.
>>>
>>
>> Ooh I just noticed you'd like to balance replies as well. Nevermind
>>
> 
> Also, the bonding could be in a router in the middle so no way to read the mark.
> 

Yeah, of course. I was just thinking from the host monitoring POV as I thought
that was the initial intent (reading the last set's discussion).

Anyway the patch looks good to me,
Reviewed-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

