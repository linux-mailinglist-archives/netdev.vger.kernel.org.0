Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D289036D9C3
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 16:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240181AbhD1OpX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 10:45:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbhD1OpW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 10:45:22 -0400
Received: from mx0a-00190b01.pphosted.com (mx0a-00190b01.pphosted.com [IPv6:2620:100:9001:583::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F995C061573;
        Wed, 28 Apr 2021 07:44:36 -0700 (PDT)
Received: from pps.filterd (m0122333.ppops.net [127.0.0.1])
        by mx0a-00190b01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13SEeCWO013027;
        Wed, 28 Apr 2021 15:44:14 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=D3uFryjwCLkO4aqyFoGkzGIDW5ZA22t8YWLsstLrK50=;
 b=MU1gH8Oebps7MqC3AoqbWxS5q8OHaBFquK2a5hKA3df83DJ+RNHnHdp01v+F6ZIOgVQI
 s0XjB8h8i81fYrPaE9AMEi0HzlahDi6ayUuBwZVxlnf/BYIpOdCFK2f/DXMAeCndLN/D
 M4kUx/fNyPGfRdb+FmzElCxaki4E4dGToVjuviW79Hk+FvL18oWq/JBwpUkO3bNozgNY
 QYXmo7AIicy9ZTBdqXMua8NHSj1WP8yi1htn9sOsDiLN91cyL9iQUSRWS8ce/86n2m3+
 rzzDrVfVYuUCW5ixItPvMY0JwOCYgkttpyA37WvluN2d+JztD8Ox93QCqAIZOpfaZ+jt Rw== 
Received: from prod-mail-ppoint3 (a72-247-45-31.deploy.static.akamaitechnologies.com [72.247.45.31] (may be forged))
        by mx0a-00190b01.pphosted.com with ESMTP id 3873my2rs7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Apr 2021 15:44:14 +0100
Received: from pps.filterd (prod-mail-ppoint3.akamai.com [127.0.0.1])
        by prod-mail-ppoint3.akamai.com (8.16.1.2/8.16.1.2) with SMTP id 13SEJsMl005286;
        Wed, 28 Apr 2021 10:44:13 -0400
Received: from prod-mail-relay18.dfw02.corp.akamai.com ([172.27.165.172])
        by prod-mail-ppoint3.akamai.com with ESMTP id 3877g611e5-1;
        Wed, 28 Apr 2021 10:44:13 -0400
Received: from [0.0.0.0] (unknown [172.27.119.138])
        by prod-mail-relay18.dfw02.corp.akamai.com (Postfix) with ESMTP id 9F7845A7;
        Wed, 28 Apr 2021 14:44:12 +0000 (GMT)
Subject: Re: [PATCH v4 bpf-next 00/11] Socket migration for SO_REUSEPORT.
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc:     andrii@kernel.org, ast@kernel.org, benh@amazon.com,
        bpf@vger.kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        edumazet@google.com, kafai@fb.com, kuba@kernel.org,
        kuni1840@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <a10fdca5-7772-6edb-cbe6-c3fe66f57391@akamai.com>
 <20210428081342.1944-1-kuniyu@amazon.co.jp>
From:   Jason Baron <jbaron@akamai.com>
Message-ID: <fabd0598-c62e-ea88-f340-050136bb8266@akamai.com>
Date:   Wed, 28 Apr 2021 10:44:12 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210428081342.1944-1-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-28_09:2021-04-28,2021-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104280098
X-Proofpoint-ORIG-GUID: Q-5AMRCt-IDEfH9fOxWkItnpW_TB25eD
X-Proofpoint-GUID: Q-5AMRCt-IDEfH9fOxWkItnpW_TB25eD
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-28_09:2021-04-28,2021-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 spamscore=0
 impostorscore=0 priorityscore=1501 adultscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 lowpriorityscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104280099
X-Agari-Authentication-Results: mx.akamai.com; spf=${SPFResult} (sender IP is 72.247.45.31)
 smtp.mailfrom=jbaron@akamai.com smtp.helo=prod-mail-ppoint3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/28/21 4:13 AM, Kuniyuki Iwashima wrote:
> From:   Jason Baron <jbaron@akamai.com>
> Date:   Tue, 27 Apr 2021 12:38:58 -0400
>> On 4/26/21 11:46 PM, Kuniyuki Iwashima wrote:
>>> The SO_REUSEPORT option allows sockets to listen on the same port and to
>>> accept connections evenly. However, there is a defect in the current
>>> implementation [1]. When a SYN packet is received, the connection is tied
>>> to a listening socket. Accordingly, when the listener is closed, in-flight
>>> requests during the three-way handshake and child sockets in the accept
>>> queue are dropped even if other listeners on the same port could accept
>>> such connections.
>>>
>>> This situation can happen when various server management tools restart
>>> server (such as nginx) processes. For instance, when we change nginx
>>> configurations and restart it, it spins up new workers that respect the new
>>> configuration and closes all listeners on the old workers, resulting in the
>>> in-flight ACK of 3WHS is responded by RST.
>>
>> Hi Kuniyuki,
>>
>> I had implemented a different approach to this that I wanted to get your
>> thoughts about. The idea is to use unix sockets and SCM_RIGHTS to pass the
>> listen fd (or any other fd) around. Currently, if you have an 'old' webserver
>> that you want to replace with a 'new' webserver, you would need a separate
>> process to receive the listen fd and then have that process send the fd to
>> the new webserver, if they are not running con-currently. So instead what
>> I'm proposing is a 'delayed close' for a unix socket. That is, one could do:
>>
>> 1) bind unix socket with path '/sockets'
>> 2) sendmsg() the listen fd via the unix socket
>> 2) setsockopt() some 'timeout' on the unix socket (maybe 10 seconds or so)
>> 3) exit/close the old webserver and the listen socket
>> 4) start the new webserver
>> 5) create new unix socket and bind to '/sockets' (if has MAY_WRITE file permissions)
>> 6) recvmsg() the listen fd
>>
>> So the idea is that we set a timeout on the unix socket. If the new process
>> does not start and bind to the unix socket, it simply closes, thus releasing
>> the listen socket. However, if it does bind it can now call recvmsg() and
>> use the listen fd as normal. It can then simply continue to use the old listen
>> fds and/or create new ones and drain the old ones.
>>
>> Thus, the old and new webservers do not have to run concurrently. This doesn't
>> involve any changes to the tcp layer and can be used to pass any type of fd.
>> not sure if it's actually useful for anything else though.
>>
>> I'm not sure if this solves your use-case or not but I thought I'd share it.
>> One can also inherit the fds like in systemd's socket activation model, but
>> that again requires another process to hold open the listen fd.
> 
> Thank you for sharing code.
> 
> It seems bit more crash-tolerant than normal fd passing, but it can still
> suffer if the process dies before passing fds. With this patch set, we can
> migrate children sockets even if the process dies.
> 

I don't think crashing should be much of an issue. The old server can setup the
unix socket patch '/sockets' when it starts up and queue the listen sockets
there from the start. When it dies it will close all its fds, and the new
server can pick anything up any fds that are in the '/sockets' queue.


> Also, as Martin said, fd passing tends to make application complicated.
> 

It may be but perhaps its more flexible? It gives the new server the
chance to re-use the existing listen fds, close, drain and/or start new
ones. It also addresses the non-REUSEPORT case where you can't bind right
away.

Thanks,

-Jason

> If we do not mind these points, your approach could be an option.
> 
> 
