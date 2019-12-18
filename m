Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6411249AC
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 15:30:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbfLROad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 09:30:33 -0500
Received: from mout.web.de ([212.227.15.3]:49913 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726921AbfLROad (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 09:30:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1576679422;
        bh=dW9ELnC9zxDtaU4OEuSlVjglUugRcBe15kK3SY4VLws=;
        h=X-UI-Sender-Class:Cc:References:Subject:From:To:Date:In-Reply-To;
        b=j0mOYvSpd11QONhR3s12w2blto5/SqKiXab8hzrmlJECGURH0UGJwtbhc7vz75yns
         EbbZDs/SpT650+hyTxtG2njOkeW88GVGB0eW/qBURF3j57w5U53BofrlZV8J5eRVgW
         euBZp0+gcv8qjizswYYAYEFdGoEjhOs4bgXdVJ+Q=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([78.48.44.150]) by smtp.web.de (mrweb002
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0MhUQ6-1iL5NE1XJy-00MeCB; Wed, 18
 Dec 2019 15:30:22 +0100
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Lendacky <thomas.lendacky@amd.com>
References: <20191218140102.11579-1-baijiaju1990@gmail.com>
Subject: Re: [PATCH] net: amd: xgbe: fix possible sleep-in-atomic-context bugs
 in xgbe_powerdown()
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
To:     Jia-Ju Bai <baijiaju1990@gmail.com>, netdev@vger.kernel.org
Message-ID: <acf52984-cbb8-578f-015a-07a071439bcc@web.de>
Date:   Wed, 18 Dec 2019 15:30:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191218140102.11579-1-baijiaju1990@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Provags-ID: V03:K1:ImmAxBS4k2Nlt5946E0XowytD+OraFYvEr2LpQNvvrasfr8vhBW
 dXn3xW22XN2mwmeHQn0S76cCq63WiSOfXQ8IqGO09Oxe507bLKR0+SG01pXFdfWNJuLXjno
 RkkjjbMCOcVPVwUppvsj6hGS1FYOf/SEcxJmy8xXVIbVH+YgoXPj6L3GlsyrOM3UDZmXiym
 Ul68CeOqRMtrd4WNx6Ahg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:6fZCSlwdtro=:PtNsbRKXt25ThJXQjNLR/9
 JUiJYbKP5+bPn6AL4dl5SNSpN7WRcWcJI1oQx7BHfYjGimOUrOvaWclX3zyCEtPXIrEW3ygHy
 JK7DsSwp7u9bwBwvv8SghA6l/qbN8CLwatuH/pNCaw29//s2cJZTYMjbzdVPi22BHatc8X+cF
 SrqpLDazCvBvlp+OOoqU9ThYXz1xnAD+MO4zNyUVwhiEcp4GgnD6In205Dyfa+MQ3kKB1R/cN
 oDDg7MtbWR3LlIcvdR8/0+HwNRCR4skOHJFUIcO9+nxVc4VrG55Ps2T/0TabR9uQyZZSzoAH/
 k8U/YFpbNgN3/MXJjozHsp/YfywRug7gTfuDfDE5hwhEV5lz2v4QmsHK6Bd15/Hdy+kXpheAB
 yUfWxOiPhp6rDQre6xklykFj6FG3XmenK7yWM7z3XDU8NAQLUC/fN0r2S8FZ0d5Ns9aVQp0PA
 1udl2yjg4Gf2Q8St2ptG7/XzTpH9+yGe+OQsvtjb4hYHahKgy6pFCoGH2vU8RuwqJWhKYF5jz
 OHdcG5Bhwy7vUBZQD9fdMX0+iwYuQi00wsliHE5WY+a6DVB0mTOKj1mLPhi0xqoe6DbQx3uHM
 JavPsRbIeKWQTtxHOJ3ksdwqZ1+JRyBpqJzYifalpg3J0Z9AKiu3OXA17ubxm5MPFjijnn/yf
 eizlkgMNQaBS0ve1vL21Pqbt82WHjJijSpZBnOBTPyXFJZ0pWOf9dov9T3sVjTU3viz2PL9Xw
 i1GZ5n+5Cqb394L/fRa2Pp07KsLydIXiqaPa8kyRr2Rm7I72WcmCrmcIooBVd6S4wSDAB8770
 is8Hgn8PEUjYtYEePXUSnO+U1xtm0VuqoCVLNBiJabaziWjcRXol0dEFn/4n/tC1k5HHEXznP
 iBlrsm0PlIpQoPvboXyt3gFQP7hWRMMjetw1CaMx/Ag2LTik1aRvCNCl2ndZmXoafyUv/w+ZB
 2KsTfeu+AsqCZQJrkp7VZcHD9rhIPKIpyBK5QT2vsQZzwxdQgUgJykQyLSX+ZtDmNiVzG2N56
 gc7Bjuj19y5fu2VPRapKHWFMMavMdbqcXCH5EJij4hVTZbD6PtTKAkAEDhSXwKvIWDI71gW5l
 3TTQjg1MjwK0EbF9+9/BdQFjJDGDu7o2e5plZdNUrpT5kzkPFRdRaTYAHiaIeXMVmnFCzFP5q
 4s7cAY9gs4nksNk9IEYKMvBFyLhaOgJ49dxyPYlcDZyrm8xWwcjnxB3qx3XwXEjV1/lHG4MhA
 w4m3GyjZsd/Q7OFqTzDAP8RlQr2B1khfovsuxJvpcQudoJasrtVxdZhRL1ow=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The function call path (from bottom to top) in Linux 4.19 is:

Does this Linux version need more adjustments than the current
development version?


> These bugs are found by a static analysis tool STCheck written
> by myself.

Would you like to point any more background information out
for this software?

Regards,
Markus
