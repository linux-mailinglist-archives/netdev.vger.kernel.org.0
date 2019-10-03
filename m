Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7B4C9562
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 02:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729065AbfJCAKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 20:10:09 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:40249 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbfJCAKJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 20:10:09 -0400
Received: by mail-pg1-f193.google.com with SMTP id d26so599540pgl.7
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 17:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gV0glpXpBw8j/vCrN6DZNwLF5XQu6WDEk6XrBmkr0zc=;
        b=ePYZ62Tw3/DB4bgH9xdH/axWJgFWQ2DEOMM/flIr5JUu4QCRlSUEWSRVol1Igtw0j3
         hfuJ4sHzeQxq8gXlRo+E7rB+7mV1uCMTeTSF2ypKC20OJKUow7QrZNgNZTLlQN2u6rFH
         OSqIqqPHz8pAiWuzXTUE+BHfpC6GaqsrTxPK4eNMfuZYigyM8VlD7NyQOYV//5+gmhB/
         mhJm2xCgPIElh98rRgVlczGKpaC1mzikxbxjC4kac3yJbaLDY31TYySUJ5v6pv8TrsbW
         xToWyOQno45MaEqTYIF6sJ2Q0VSbzvEpQFkd2myhD/Q83PZJZDwy1A4fQ2r2DrJItSoQ
         OmgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gV0glpXpBw8j/vCrN6DZNwLF5XQu6WDEk6XrBmkr0zc=;
        b=gN6WeDNGe0h7w9OsKOalpKtfhCaWdhDOGD0nRXf4BId6wDy5PXZBe3wCFszkqm6G8O
         8TNbhXA1FBkCyMMXvUFcVxCIdY0NHf+H0koQP1WRZptWBrFvwkhFjsiaLw6XACTm0Qvu
         IUJC4jKmPMKd9ydwcef5Zo8KqixxIY+dSUhLr3KC6qhXQrRhF54YVyqlF5P4YKuWdbD9
         yfuvKelOo3Rs1lfuOtWwjjiH/Sevm1JqCt4jYJL0D2wFmINInzpsLf4SSDSsZZx6GjHH
         14ywz2BADyjrFIDaJilhJK4ZQ1uqVOu0VJ+ZY7FHkD0/eworKuUo7fpSxt7Mpw+FUjBJ
         O2yg==
X-Gm-Message-State: APjAAAUu75i52ulS/rqk0o0MbMxNTVYQF8aTP7nZuOsEfQV9SAxuIRjf
        a0WijA6pJoSQG5acrbMEaGE=
X-Google-Smtp-Source: APXvYqwvy0wH7dC4MNA2DMGkJ88mtpfUPvsTRQX/Z66BvtvslSuPk3J1ECO0liLzQvKgPB1xCYZa4Q==
X-Received: by 2002:a17:90a:a78d:: with SMTP id f13mr7333427pjq.18.1570061408703;
        Wed, 02 Oct 2019 17:10:08 -0700 (PDT)
Received: from [172.27.227.238] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id c10sm558920pfo.49.2019.10.02.17.10.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Oct 2019 17:10:07 -0700 (PDT)
Subject: Re: [PATCH net v2] ipv6: Handle race in addrconf_dad_work
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        David Ahern <dsahern@kernel.org>, davem@davemloft.net,
        jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, rajendra.dendukuri@broadcom.com
References: <20191001032834.5330-1-dsahern@kernel.org>
 <1ab3e0d0-fb37-d367-fd5f-c6b3262b6583@gmail.com>
 <18c18892-3f1c-6eb8-abbb-00fd6c9c64d3@gmail.com>
 <146a2f8a-8ee9-65f3-1013-ef60a96aa27b@gmail.com>
 <8d13d82c-6a91-1434-f1af-a2f39ecadbfb@gmail.com>
 <3dc05826-4661-8a8e-0c15-1a711ec84d07@gmail.com>
 <45e62fee-1580-4c5d-7cac-5f0db935fa9e@gmail.com>
 <7bd928cb-1abf-bbae-e1db-505788254e5b@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <6b74af81-d12d-6abd-fd4f-5c1e758fdde7@gmail.com>
Date:   Wed, 2 Oct 2019 18:10:04 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <7bd928cb-1abf-bbae-e1db-505788254e5b@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/2/19 4:36 PM, Eric Dumazet wrote:
> This might be related to a use of a bonding device, with a mlx4 slave.
> 

does it only happen with bonds?

bond shows IF_READY even though the underlying device is carrier down
which seems wrong; if a lower device is not carrier up then DAD does not
really happen.

A quick test with a VM (and setting carrier off on the tap) shows that
with the current patch in place the bond address stays in tentative
state. Reverting this patch and the tentative flag is removed. DAD never
happens since carrier is off on the one link in the bond, so the
tentative flag getting cleared is wrong.

I need to step out; come back to this later.
