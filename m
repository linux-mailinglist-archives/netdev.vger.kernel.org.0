Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7F8D1A9823
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 11:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2635945AbgDOJNj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 05:13:39 -0400
Received: from mout.web.de ([212.227.17.12]:44603 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2635935AbgDOJN3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 05:13:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1586941975;
        bh=aF/C7Wndq+5/EojKQWfWa0n9swu/SKYhBYliHCYiM1k=;
        h=X-UI-Sender-Class:To:Cc:Subject:From:Date;
        b=gCRce2tzBrlAFJx1eeMLqXHnHZz15R3Isrn9BET6G0hxd4Ee/gT8EZF+FHJrOqwCa
         dkNOOavxCz8kHiH3MYLzXsEVlmm7oW5dHTHfdJEmtYztNLg7zHHUWHl48SrgySwPCd
         JkAaQsHG6U2pRkuhUszwk7dVgAzKSIQwRZ8/jsEA=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.3] ([78.48.133.192]) by smtp.web.de (mrweb103
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0McFLP-1jeoCm2fJP-00JZAF; Wed, 15
 Apr 2020 11:12:55 +0200
To:     Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>, linux-wimax@intel.com,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
        Kangjie Lu <kjlu@umn.edu>, Yuan Zhang <yuanxzhang@fudan.edu.cn>
Subject: Re: [PATCH] wimax/i2400m: Fix potential urb refcnt leak
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <517c4bae-d34c-855f-1872-2eed37eed54f@web.de>
Date:   Wed, 15 Apr 2020 11:12:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:ZncVkhbtrnKLLwUNQ2aGkrSYO2tmuC/VkDiRQ6UC9Y/NTOTc/sZ
 2w41dsK7RMaXavT53d7UYqU5g2ethfuqWK9cD80YXwRcZz8yvnngeGAv2QiFTKO9TtrxKKV
 l7Ux5QspBF3L5V33jPsj9CG1NxeGJCLZDAJ/ika8KePmwVkIMMTy66IFkBwN4sUb6Wv+PxY
 rSMCISL3LXLAU7Atshx5A==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:PTnxMbnxWKk=:UoUC+bztBu9PYEECNA6P83
 PuTZrEizWXvds+UFQnRz3iw3iI3rwyBZsXHgFhUhW8BuhhwyyhdR3RvakBIGhb8mm3atYttfU
 nUfMqYQWRAWnoNwnPJy4EHBi5EuUzIiPcf1GT7eSzaSRS+IMFCly2zCiZ+BfABrT5yekIlvG7
 K1ftKkSUY/d8aJPjHBnTYiLwilt4yZdDBh9aPgSLVQh5WBh+zwYcY+FHYhb4zdzz4LVVtkcBe
 ogiK7U/j3qp3Tcl5ggstALRkz72vJIFAVjPZWFo8jZHpgg03DIxTNDNsaoAr8B7NSFyRJpk0N
 LZYoxuRhaYSU7eHRFtPIf751Lynz20lFMKXS2uhviFZdyx1WhUDFBYdqDgutEeawnJQ44oZ/d
 zSfW/nwxbItdV67S9EKwyC4+4zNuGsp88976YPIE5y1elUNASm9tJQ6SZQS6LU0Mg9aF/om4o
 W3cp2TyPL+eG31Hkk8MSl4t0Fa6nRUEAq0U8beKJfwHyT1L7oQyYYRR6Ozicbm43viMSoHMqi
 I8Gh5fqOA22oPQBDiYLD2zlla7BHjPz+eZvP+nVAeilqr8WbS8bfPJN5gRx+RFsjkrvVD+E+U
 3yozBs5gLjm9jKBCoSm1PlY3SQo3Er+5hpNez6Ct0ImDt8IVS8EP+2c77Uj+FJdjLcGWFhUSz
 4+bKE94mLSG2ayiD92yMZr01ivFT+cmQJ5pfw22vNID6RQ14yF7Imm/T3zMpwv/yhwwtbdvBV
 18TsEe5yODk2NbfU0PNAnQzd5wJz9wToxZN3Ec17lBd7q1QErHO2WbY7fnY2ghjYYjhDFiStI
 d2G1WCLiV8iXChPPbO+6pY5xHvbKgOP+wpYuJm/jm8ejZob7lZAqcsOnDTydcwFxbcJhO+CO1
 FgglKvrMg+IBvuyMPuX3YoO7nD2HCbnAzMZTrybr9nTah3nLbG8PDIofswYWutzhRQexp7CKT
 YxweuTRdOOuaocGAcaXXjmhL/XfMAvy4lTbkJ1JyV1LAQm3Jb36kk3sMq2wWgLUbFMuhTI5T6
 bbE2wJxzFbS2ldWztljA42Rrvc6wbmkBRZOp8QZlx75zNUQIw2CVT267xufbs4LL1MOPacWJO
 2y5VYY9eUqnxqCJJ5OPMpYq0gxHU+5z4KvQVsGa9dQGMp86lQLsr4PtRsWE2KIyijqhhlzdaf
 Jkh6jj484n2uaHWyUMYksQyDpWOpqtZyh155Tr5SXCUKrtwXq46Sw9zZJHW07T4mn57OLyH1G
 o811f8nJMYAAA+k8r
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The issue happens in all paths of i2400mu_bus_bm_wait_for_ack(), which
> forget to decrease the refcnt increased by usb_get_urb(), causing a
> refcnt leak.

How do you think about to mention the term =E2=80=9Creference counting=E2=
=80=9D in
the commit message?

Would you like to add the tag =E2=80=9CFixes=E2=80=9D to the change descri=
ption?

Regards,
Markus
