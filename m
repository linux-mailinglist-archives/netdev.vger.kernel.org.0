Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AFEB2324C0
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 20:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbgG2ShK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 14:37:10 -0400
Received: from mout.web.de ([212.227.15.4]:50271 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726336AbgG2ShK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 14:37:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1596047799;
        bh=MUCJ3cp+dXeXVH8kcCad+QqTN2WS3m9rEsqklOia9Sw=;
        h=X-UI-Sender-Class:To:Cc:Subject:From:Date;
        b=H9OZGTAUEKwqTLTCHDeuWT323sdp9bbAk9TcDj1wpzVoabKCwU7XerkYh7X9pGNnW
         qdvHVmaETA0BvK0ga2DwmhDoInmYZnbm8qSjJA6hriWamFOog6fA8TuQgBlHTjD0ge
         XT2WO6Qi+IyXY5fA4LQD6Ll6vzmcx/dKXsS827g8=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([2.243.175.129]) by smtp.web.de (mrweb004
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0Lvf5Q-1kqPJi3VN6-017Yha; Wed, 29
 Jul 2020 20:36:39 +0200
To:     Xin Xiong <xiongx18@fudan.edu.cn>,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>, bpf@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Leon Romanovsky <leon@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Yuan Zhang <yuanxzhang@fudan.edu.cn>
Subject: Re: [PATCH] net/mlx5e: fix bpf_prog reference count leaks in
 mlx5e_alloc_rq
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <810e5783-ba95-6d2f-0f89-171dd3b688df@web.de>
Date:   Wed, 29 Jul 2020 20:36:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:r0zfwJMed2KL5NZGgiS4wFM4dzmNTm1rUzJDCSPBX2vHNdmwOLt
 UhWmDTXbwzpNDY/J773o/lhmstFXL7brkx2Bescq1b44f7wyyA9yZiQKRMwcZOgT5qrE5Ko
 NjyStIAK/ThC1oNJlKLuERp8ImMSmUcrYe7R9FlvEC4TVeF7jeSoqL+Zqvn+1QnzU5lwCFC
 nFn3WmKRBIIWN7wS7d2rA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:TXoNdttfv98=:aw1/2V2I7mCxFvyd0uv9HZ
 qXVEOGZkCXiZU4HGl8VLjPW3MhcFy4rFRXns3IXpn6xmYYb97cVg8UqL9tfuQss4ueFTsNBvl
 rED4WW7Svc3dTmApH638VKHTGR+an/4M4ttzpl4CMxShothyTBEh1aDkcNE43TUkBKFxDVQKn
 FU6h8gB9AbRHrJRddRdgVootBnCPghV/ZjrzF/48x1IbOVoQV32n62l0cvgwtAwgMj7sZA3rr
 NV2OgXXPXeWfWnmteXfNTJgA7qb75ufyOwMwM/s+Ncn+gjwX/Pa9Z9v9TimZP2ums2GnaHxY0
 S+uxV4l5I5q2ybjGJmqGBT9AUDxj3CLZhqAfPdfThBLX3wKnk17gxgxrWl2WyppTwHJXEM4VP
 sSUxJfXxAyKCws5YT494zs6DzC3tJYNkEaKMvnPDWHL6Y82hMgR7dLYqlN2BRigGPbdhqXS6F
 anmjRpqDCruaFYZHDW3rV8UQ8GhDxLcTn1P3iIO4hG/JkyZYWlMQtzFBl4Du3kD2h7tmi9V5k
 IUr3g7gJWMT1NOzYdZZ84MserVz880Z7xGV1zrearqVWJQQBgd+a8NYWcT3TTvQXakKdDx1fp
 dC8U92elDLHry7jG72J/yluMOhMRfMLHlQzcJE1wA9t9vZCJI+y1UcYdt7xnwaN60YLaP2tRd
 c6xKclgEw8l9oVkwB+sbAdr1DI5ofjfx9Z8wgyzEzmMuIshphePHJixrIUqeWUnxGMKfbg3tQ
 LGcx21fo+W9+0TCaheJLJcwCivkTH3nOgs9YpnYjCZsyKZgPEyU5PXoBTXXecT9h6Pl9p5gkU
 e6MrOxBW1OeSyAyj/sFXlFRGhXSd/zEVA5VPof0pNjvjHklRsMPwty1Vau7gIWUg/77he6c0l
 dIaJ3RJ76R2MLKJo31sl2glVcERNTCGPEZ3GmnKp35vqne0k3WKNaiFpTbVAqIYaP2084lUQN
 w4nQ7mtAqGOlyL49ui1/FmqmFj8K/fOZ+kdWD4OLF4kPBZfU6SdBP/HMJnJkNaWWaLN/9t/SN
 DbohVJhIJT4yXDXe8po1rGPy3+lWdW+1PPFnbtB28P3o6PJrePre/h8jsPRoKE9z9rUJUVpF1
 d7aQDoqh4YH/GZcGz4uC4g+822afBErwCwI7jD/Ag6W9blojH7ydotWRs8vTO8sYLFrVUoN+a
 klO4yIL37wG42xJDQuL0rkz7dsbqYzncqti7IBmLzMgXV9u4+xU27d9ior5AI6iARecj7W01t
 0Anr5W8nicfm57mqHrcUItTkvSUQ/9+Mu5UHbKw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=E2=80=A6
> The refcount leak issues take place in two error handling paths.

Can an other wording be a bit nicer for the commit message?


> Fix the issue by =E2=80=A6

I suggest to replace this wording by the tag =E2=80=9CFixes=E2=80=9D.

Regards,
Markus
