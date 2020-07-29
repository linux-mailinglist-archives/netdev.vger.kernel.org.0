Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79EC8231B59
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 10:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727897AbgG2IjL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 04:39:11 -0400
Received: from mout.web.de ([212.227.15.4]:50469 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727837AbgG2IjK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 04:39:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1596011925;
        bh=0nHnWyTi1/5z4jViX6/fk8/97w0RRKZVTE+kBJBTFJY=;
        h=X-UI-Sender-Class:To:Cc:Subject:From:Date;
        b=dL3EnT1ytm6BHpdkhN5++VEgxre61wCfDjqFXylyB4mrtsksKtyBOd8rcG7T7FgPR
         jMxqJeDOiJBiuOHm2k9pdQ85MpTioN0pYv/v7C1D7YKY5E6H+RYmwFcHP7pC+qRU6w
         SOo0LxLQ+WlixKuoS6kbX+e6h8EeiALBZ6A7gfQE=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([2.243.175.129]) by smtp.web.de (mrweb001
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0MVcvn-1kHV0s1LPb-00YwEd; Wed, 29
 Jul 2020 10:38:45 +0200
To:     Lu Wei <luwei32@huawei.com>, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>
Subject: Re: [PATCH] ethernet: fix potential memory leak in
 gemini_ethernet_port_probe()
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <c9c7e5a3-4909-e0c9-1c69-0ad3643ca3f5@web.de>
Date:   Wed, 29 Jul 2020 10:38:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:DIURh6r5a5qyKYK5piPq9bQqL5bdgzfI0Lt5o3pwFgdexj93y0b
 9iccCfI87+I2IVXyJYPWYgr2lh9qEQKxMPJnTAUz6GABamYHjFUYjK3x6ZuXthiVqjSWAGQ
 kAQIAkH+y8cyEFJjznuJCJKdEEbp5Ud9alJglAROU67Th4b2ZK7xUGZUKDXb9cp57ei/QcW
 GYLe8KFCtWOwj4FGsQWRQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:CvAf/U/2krw=:jnm5GT4alMrsp5cOHacWIm
 V1iIXBhpPKa4zfqA+WBmO/gCoklqsKNdDsFeuBAH4pIR94mL/IbTGefc9KVqUYqlOMpMwL4nB
 J+7N1jZvLI8xyaFrcRdnyTOBOVAAic2pMiG9JqnGe7h2pxQevgXwQ6iF1pbm1G/v8Rd05ae/5
 eZqGNrwID+QaSwVS3OZ3G6OmhOTurYqfu9VdYkNmh1AeHttgsmnTLusY8BOrPAL4kiNAys5Si
 uTGa2viILDKASi5SDFwI+CDzhQDJXf5lXcGV9yobL96Y84TNU+868PuBp1UkDbsXA3zGiYW5f
 WzjYp783dwbD9Aebi/RYFEG5UZ3mSDC48qLInfI9OdywZjGIxB7q9GZIowyNHmZpEFvPfRziG
 jMp6KGUXkSPpnrDY+iL1E7n7xqYt3uouJjJ2iJHl5sPM+1ctMo0ttvauCWGTbYuSJbXccosco
 4prBJasX3dNWmGKZfLApAiDmtsd0bVWlQWRuOe0udYB+pqDSLASuEZ3kmfQNlHkTtRbLSDiXZ
 1ws2tKX8IeKYtDSNg7k/inyHnB0K2OCSODeNgQ6li1E8pzod+08YSNWdVQ4V8N/yYeR9q321t
 xmyl3Cj4w+CVwj9c20hNjpSrHg9W4eWDapqpoJcN0nh/vLmHKZwKzrEiBJ0ruEkp/wUMsoOpR
 dx80wd/bEFMXk9zlpZUJ/dmmyuuHXIdm0KSFI1cwxCe8sGbGjBE8s9XuPqFBuP3GxmkcWgV1d
 2/L0Uwu2wnF6H83uZxSHvK2RgL3HWKZSlzM4Sz/Ip1RMqQTE4XXhaOUlEpPNL73cWaMj5O8tr
 OF46uqsXuDRd1OzkAY2Afzv/J8Wo0u7ZJmbhpM9RtU3RyMDeDoSFwLdg5tw/LxzEJNMGJxd9e
 JnldnJGjqCpOPZLQ+ZNhiF4ULMM0x/xmyC/Zr5DuYg0p0a+Zv+XX3g6sMURug/sJJZbNKszQi
 zU09dPiOasEKyHdqfVHCYMWRPsGwZ9Nn5UO96mwsXkfEJusEBOaMXsNLyAWd2gc689hCxdfU+
 g3bFhMKVDmQ7RRbjPd5uPlnZLYj+FT1ncmTAhR13xBWNyjkwP+P1Z2wpA8RjROltBb+q70FGi
 osXbCCEr87vpF6YOxlhC8VJRWw1QnjiqHOxdGV07A9aIcCB/EQssmlkSLTbb6kio9e5aVW5su
 FAp3Wull0KboABBYhMqExz/eamPxrGWV6fBx7bSLzmT2o/EkJv/FOZ8W7HhkrwmI/YiU6M3q9
 HW6NMhXHgY2OL+Z4l/jjrc7DG3cxK+N68xbp94A==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> If some processes in gemini_ethernet_port_probe() fail,
> free_netdev(dev) needs to be called to avoid a memory leak.

Would you like to use an imperative wording for this change description?
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/submitting-patches.rst?id=3D6ba1b005ffc388c2aeaddae20d=
a29e4810dea298#n151


=E2=80=A6
> +++ b/drivers/net/ethernet/cortina/gemini.c
> @@ -2501,8 +2513,10 @@  static int gemini_ethernet_port_probe(struct pla=
tform_device *pdev)
>  					IRQF_SHARED,
>  					port_names[port->id],
>  					port);
> -	if (ret)
> +	if (ret) {
> +		free_netdev(netdev);
>  		return ret;
> +	}
>
>  	ret =3D register_netdev(netdev);
=E2=80=A6

I suggest to add a jump target for the desired exception handling
in this function implementation.

 	if (ret)
-		return ret;
+		goto free_netdev;

Regards,
Markus
