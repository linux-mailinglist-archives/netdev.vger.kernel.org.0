Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0212A3D2101
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 11:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbhGVI4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 04:56:42 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:54126 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbhGVI4m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 04:56:42 -0400
Received: from fsav119.sakura.ne.jp (fsav119.sakura.ne.jp [27.133.134.246])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 16M9b0cC038549;
        Thu, 22 Jul 2021 18:37:00 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav119.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav119.sakura.ne.jp);
 Thu, 22 Jul 2021 18:37:00 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav119.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 16M9b0RL038546
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Thu, 22 Jul 2021 18:37:00 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
From:   Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [PATCH v3] Bluetooth: call lock_sock() outside of spinlock
 section
To:     LinMa <3160105373@zju.edu.cn>
Cc:     Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
References: <20210627131134.5434-1-penguin-kernel@I-love.SAKURA.ne.jp>
 <9deece33-5d7f-9dcb-9aaa-94c60d28fc9a@i-love.sakura.ne.jp>
 <48d66166-4d39-4fe2-3392-7e0c84b9bdb3@i-love.sakura.ne.jp>
 <CABBYNZJKWktRo1pCMdafAZ22sE2ZbZeMuFOO+tHUxOtEtTDTeA@mail.gmail.com>
 <674e6b1c.4780d.17aa81ee04c.Coremail.linma@zju.edu.cn>
 <2b0e515c-6381-bffe-7742-05148e1e2dcb@gmail.com>
 <4b955786-d233-8d3f-4445-2422c1daf754@gmail.com>
 <e07c5bbf-115c-6ffa-8492-7b749b9d286b@i-love.sakura.ne.jp>
 <4bd89382.4d087.17aafed62b1.Coremail.3160105373@zju.edu.cn>
Message-ID: <d9ceb087-588f-a023-9f0c-c0ab46b6af87@i-love.sakura.ne.jp>
Date:   Thu, 22 Jul 2021 18:36:58 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <4bd89382.4d087.17aafed62b1.Coremail.3160105373@zju.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/07/17 0:26, LinMa wrote:
> Hello everyone,
> 
> Sorry, it's my fault to cause the misunderstanding.
> 
> As I keep mentioning "hci_sock_sendmsg()" instead of "hci_sock_bound_ioctl()". In fact,
> both these two functions are able to cause the race.

I sent two patches for avoiding page fault with kernel lock held.

  [PATCH v2] Bluetooth: reorganize ioctls from hci_sock_bound_ioctl()
  https://lkml.kernel.org/r/39b677ce-dcbf-6393-6279-88ed3a9e570e@i-love.sakura.ne.jp

  [PATCH] Bluetooth: reorganize functions from hci_sock_sendmsg()
  https://lkml.kernel.org/r/20210722074208.8040-1-penguin-kernel@I-love.SAKURA.ne.jp

These two patches will eliminate user-controlled delay at lock_sock() which

  [PATCH v3] Bluetooth: call lock_sock() outside of spinlock section
  https://lkml.kernel.org/r/48d66166-4d39-4fe2-3392-7e0c84b9bdb3@i-love.sakura.ne.jp

would suffer.

Are you aware of more locations which trigger page fault with sock lock held?
If none, we can send these three patches together.

If we are absolutely sure that there is no more locations, we could try choice (1) or (2)
at https://lkml.kernel.org/r/05535d35-30d6-28b6-067e-272d01679d24@i-love.sakura.ne.jp .
