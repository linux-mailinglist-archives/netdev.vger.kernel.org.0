Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 168596B4015
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 14:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbjCJNSu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 08:18:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbjCJNSs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 08:18:48 -0500
Received: from hust.edu.cn (unknown [202.114.0.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ED3B1423F;
        Fri, 10 Mar 2023 05:18:44 -0800 (PST)
Received: from [IPV6:2001:250:4000:5122:1445:2b8c:756a:57dd] ([172.16.0.254])
        (user=dzm91@hust.edu.cn mech=PLAIN bits=0)
        by mx1.hust.edu.cn  with ESMTP id 32ADIJ3u024663-32ADIJ3v024663
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Fri, 10 Mar 2023 21:18:19 +0800
Message-ID: <c379d193-5408-a514-9f37-eb93585557ab@hust.edu.cn>
Date:   Fri, 10 Mar 2023 21:15:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] atm: he: fix potential ioremap leak of membase in he_dev
Content-Language: en-US
To:     Francois Romieu <romieu@fr.zoreil.com>,
        Gencen Gan <u202011061@gmail.com>
Cc:     Chas Williams <3chas3@gmail.com>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dan Carpenter <error27@gmail.com>
References: <20230310102256.1130846-1-u202011061@gmail.com>
 <20230310112850.GA424646@electric-eye.fr.zoreil.com>
From:   Dongliang Mu <dzm91@hust.edu.cn>
In-Reply-To: <20230310112850.GA424646@electric-eye.fr.zoreil.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-FEAS-AUTH-USER: dzm91@hust.edu.cn
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/10/23 19:28, Francois Romieu wrote:
> Gencen Gan <u202011061@gmail.com> :
>> In the function he_start() in drivers/atm/he.c, there
>> is no unmapping of he_dev->membase in the branch that
>> exits due to an error like reset failure, which may
>> cause a memory leak.
> 
> Why would he_dev->membase not be unmapped in he_stop() ?
> 
> he_stop() is paired with he_start() as soon a he_start() returns
> anything different from 0 in he_init_one(). I see no other place
> where he_start() is used.

Yes, you're right. We will check more about reports from the static 
checker Smatch.

Smatch should make a false positive here, I think it might be that, 
Smatch has an assumption about do and its paired undo functions. The do 
function should clean up its own allocation operations. And the paired 
undo function can be only called if the do function succeeds.

+cc Dan Carpenter

Maybe @Dan could tell more about this point.

> 
> The atm_dev/he_dev pointers also seem correctly set.
> 
