Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 553384E5D3D
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 03:35:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347784AbiCXChL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 22:37:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233051AbiCXChL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 22:37:11 -0400
X-Greylist: delayed 48606 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 23 Mar 2022 19:35:39 PDT
Received: from m12-15.163.com (m12-15.163.com [220.181.12.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 27AE0939B3;
        Wed, 23 Mar 2022 19:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Message-ID:Date:MIME-Version:Subject:From; bh=jFDwM
        cIllWOoj/mFpbnGLqeFbi8jE9VmXsc1mr3U7BU=; b=UokiijMM9JGWLgM020Jvu
        F8mXEtPbR++QqKXzfbp7ZvfQgV8b7H1R5SzfddaM3Nbb4+/g6R1IppqyR7z7+R7T
        a9ZU4WPbhoxfpxij682+2bwN+NRHNqNNAolm2BEttQGx1MuHLBGi6tWeFzd/3Jnb
        zDbVpplG9eD9nhXKb/yyWg=
Received: from [192.168.1.13] (unknown [120.36.172.115])
        by smtp11 (Coremail) with SMTP id D8CowAB3jrKL2DtiQj3XBw--.62S2;
        Thu, 24 Mar 2022 10:35:21 +0800 (CST)
Message-ID: <b1342885-3aed-9c34-8f6a-aa681369ad27@163.com>
Date:   Thu, 24 Mar 2022 10:33:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net-next] tcp: make tcp_rcv_state_process() drop monitor
 friendly
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Menglong Dong <menglong8.dong@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <3eb95fd0-2046-c000-9c0b-c7c7e05ce04a@163.com>
 <CANn89i+v=yOd8=-i9cd=vL9U7Q8W0RRNco6CVFv4+Cx6Dj0z5A@mail.gmail.com>
From:   Jianguo Wu <wujianguo106@163.com>
In-Reply-To: <CANn89i+v=yOd8=-i9cd=vL9U7Q8W0RRNco6CVFv4+Cx6Dj0z5A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: D8CowAB3jrKL2DtiQj3XBw--.62S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrKr1rGr43Gr17ur4xCF4DArb_yoWDZrXE9a
        n0vws7Gw15Xa4xXF4ktFWqqrWvgay8Jayjq3s3trn3uas3Z3sF9r4DKan7ua1jq3yIvFnI
        kFWYva1qkr13WjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUbFksJUUUUU==
X-Originating-IP: [120.36.172.115]
X-CM-SenderInfo: 5zxmxt5qjx0iiqw6il2tof0z/1tbiNxfMkFWBm7L9qAABsV
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
    Thanks for your reply. This is more complicated than I thought, i will do some more dig.

在 2022/3/23 21:40, Eric Dumazet 写道:
> On Wed, Mar 23, 2022 at 6:05 AM Jianguo Wu <wujianguo106@163.com> wrote:
>>
>> From: Jianguo Wu <wujianguo@chinatelecom.cn>
>>
>> In tcp_rcv_state_process(), should not call tcp_drop() for same case,
>> like after process ACK packet in TCP_LAST_ACK state, it should call
>> consume_skb() instead of tcp_drop() to be drop monitor friendly,
>> otherwise every last ack will be report as dropped packet by drop monitor.
>>
>> Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>
>> ---
> 
> 1) net-next is closed
> 
> 2) Same remarks as for the other patch.
>    You mark the packet as consumed, while maybe we had to throw away
> some payload from it ?
> 
> You will have to wait for net-next being open,
> then send patches with one change at a time, with clear explanations
> and possibly packetdrill tests.
> 
> I am concerned about all these patches making future backports
> difficult because of merge conflicts.

