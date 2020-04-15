Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 192C41A9912
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 11:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895644AbgDOJfy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 05:35:54 -0400
Received: from mout.web.de ([212.227.17.12]:37303 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2895613AbgDOJfu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 05:35:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1586943301;
        bh=ezw4TLO8n8l15GvUg+iOtElfoPwFhfpISR9wA5pB/EM=;
        h=X-UI-Sender-Class:Cc:Subject:To:From:Date;
        b=A1ZwyGSoLP7tROnrOqdHfWgLWbN7cDdFDml42VlKT23D/YhkXOUPrtYyIdgZp+xzS
         tq+u2avCm2pEIYFG/ECQKdHP+TC3+UQZTUSjUr3y5pGCDPtmbiU9jo/rhVZAu6hCGp
         XEgcgg/dHLQPjTB6/x9nd6p4S2Zh83F5f0ITVPk4=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.3] ([78.48.133.192]) by smtp.web.de (mrweb101
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0MBkPj-1jW6hm2ghb-00Ap6c; Wed, 15
 Apr 2020 11:35:01 +0200
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jon Maloy <jmaloy@redhat.com>, Kangjie Lu <kjlu@umn.edu>,
        Ying Xue <ying.xue@windriver.com>,
        Yuan Zhang <yuanxzhang@fudan.edu.cn>
Subject: Re: [PATCH] tipc: Fix potential tipc_node refcnt leak in tipc_rcv
To:     Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <53bb4a56-0bd2-3964-7cfb-b5745a8ba25c@web.de>
Date:   Wed, 15 Apr 2020 11:34:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:u4noMxXZAQN29VZ7DnfQnHQpVDgs3OBGHH3ZaHfbT9kBadItvZd
 KED8KsZy3rlOCi3E1qWLwTq4Qm/GSd2mVVbfEjEQGzQGzneyI/6Mz7Xq9vXAc9ggl2cGhqx
 FWPR1BlUfk0PAa+SAZlROMT3xWQ5X2mkLlI93PyPdoNyi5J7Cw6iEJdSZxqUkCalcKfHpj6
 8lZoQCGMIVzvUCMIKsEBA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:bjgr2cNAAqY=:L58s1mb6zQFpPqznJqp/a4
 dhj5iRsiALqRrokVlj6LYOrzVn3jhdvDxi9LR8LqE893BYk5gA7nDc7I2Ho+mW1oap0wa97bg
 SZOdQ1ly1PB0J1IQlvheWxzBrQ5/dSNwclmxTtgDRI/Ut9eVK5G5NKOn+Bt4VGdOpZqk1Ev+M
 W1vtEGQGLNZ9RAIETMrpXw9PWw7MpEbBsfOHuxnZemiojP0qEolndEhhKSqw7rl6Fg7EicKHE
 jhFDJiPOj1WQaoWOLg+t4nOK2+S1BMj4GC9j/Q3hJEFFoLSRh2z90vpTXcc0tFOqzt5oa9/8e
 n9Su10KKpONicLrH1F8cj6qHbAneYCTlTZ2xsj+1nIBIXJs9f0LuJWg54iuA89Wxeg8k/uzTn
 megLTVAq4aokTv9tLdPDf3/ZmzAkXyzk+SDMOw289Cv4nyPSpKW+kPqVKiXnvtmWDZbnarEpb
 1X52LQW5paTTmYdbf/dumXyAjrbpfZP+KvIo7o2XoiYNKfVRPe6kseo4jHBPgeesWkNizi12/
 iibCUDkGFjFfJxOEr0BTBFpJPtCApfpfeR+L91g5lncvwYJHYbsObjSD2e8pRhqwcfoOUJ79Q
 xf8emjO4ihAZoT65neBKp+dK39354am7GvHTvH1Mg3QarqBxvDR63SmYbvtk3diBryW16bb6q
 joC75Qcq88RG9L04o6DojqZJLRxyAJbVczFqAzNbs3j+yYyd5c75zcxUsuWvDQcOwiUP4AMyw
 kfD9o71ZK+ulyNjuu0TCFmRm21wQdw+1WUqlMg8kZDmtcWF1/0jaStnxOW1lhZb7RQ89KxSP9
 ZY8e3Z2y8OpUrFGUDE6RDkHxsrdVS+fmpwuROMP39RzyO0JeYGlV0eQ4brtubdvensuNcDOHw
 P0Eox/+m3EFqxIqAbYwPEz2CsMHCiuSZlxyr4DyztE4HMHnVBVrUJRWyxOJshcqlwHdZHCEUJ
 XNWv/lpKuyVHrRlG6JFPAFp/BWfsmJtT3/B6/vuASYymRsDQpEsdmFmWcjz8cdcvdXQN1piyZ
 b9ivLBoCIQD43WOMQKeYWJdEn+GK6kDFjUGUpvCuCOPDu2q7HZEkghqT7FXEZSWC7r1uwNQAr
 AklkQVvwau9YahSIenR4I/mKNSY3fJQsHFEPceeS9cGoGIwXPHSVT+4g/KhxbbTGTlHUmK6hp
 eQ5Rd2945QVjtgO8ssVQ2OvXgjjhrj2QH6vZGcS+TVmHTsJzzmPbrI/CX2dx93vm7rwzRQpvc
 Y2w8+sFa5B/k3g+46
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The issue happens in some paths of tipc_rcv(), which forget to decrease
> the refcnt increased by tipc_node_find() and will cause a refcnt leak.

How do you think about to mention the term =E2=80=9Creference counting=E2=
=80=9D in
the commit message?

Would you like to add the tag =E2=80=9CFixes=E2=80=9D to the change descri=
ption?

Regards,
Markus
