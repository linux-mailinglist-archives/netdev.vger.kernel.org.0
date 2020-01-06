Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA5C51319FF
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 22:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbgAFVEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 16:04:02 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:65427 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725298AbgAFVEC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 16:04:02 -0500
Received: from fsav404.sakura.ne.jp (fsav404.sakura.ne.jp [133.242.250.103])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 006L3rRk079409;
        Tue, 7 Jan 2020 06:03:53 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav404.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav404.sakura.ne.jp);
 Tue, 07 Jan 2020 06:03:53 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav404.sakura.ne.jp)
Received: from [192.168.1.9] (softbank126040062084.bbtec.net [126.40.62.84])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 006L3mLr079397
        (version=TLSv1.2 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO);
        Tue, 7 Jan 2020 06:03:53 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Subject: Re: commit b9ef5513c99b breaks ping to ipv6 linklocal addresses on
 debian buster
To:     David Ahern <dsahern@gmail.com>
Cc:     Casey Schaufler <casey@schaufler-ca.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <90fbf526-9edc-4e38-f4f7-a4c9e4aff42f@gmail.com>
 <202001060351.0063pLqJ023952@www262.sakura.ne.jp>
 <c0c9ee18-98f6-9888-4b80-c6e3e5a4a4f4@gmail.com>
 <a2612f24-00b7-7e9e-5a9e-d0d82b22ea8e@i-love.sakura.ne.jp>
 <d8bc9dce-fba2-685b-c26a-89ef05aa004a@gmail.com>
From:   Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Message-ID: <153de016-8274-5d62-83fe-ce7d8218f906@i-love.sakura.ne.jp>
Date:   Tue, 7 Jan 2020 06:03:44 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <d8bc9dce-fba2-685b-c26a-89ef05aa004a@gmail.com>
Content-Type: text/plain; charset=iso-2022-jp
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/01/07 1:41, David Ahern wrote:
>>>  #ifdef SMACK_IPV6_SECMARK_LABELING
>>>                 rsp = smack_ipv6host_label(sip);
>>>
>>>
>>> ie., if the socket family is AF_INET6 the address length should be an
>>> IPv6 address. The family in the sockaddr is not as important.
>>>
>>
>> Commit b9ef5513c99b was wrong, but we need to also fix commit c673944347ed ?
>>
> 
> not sure. I have not seen a problem related to it yet.
> 

A sample program shown below is expected to return 0.
Casey, what does smack wants to do for IPv4 address on IPv6 socket case?

----------
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <arpa/inet.h>
#include <unistd.h>

int main(int argc, char *argv[])
{
        const int fd1 = socket(PF_INET6, SOCK_DGRAM, 0);
        const int fd2 = socket(PF_INET, SOCK_DGRAM, 0);
        struct sockaddr_in addr1 = {
                .sin_family = AF_INET,
                .sin_addr.s_addr = htonl(INADDR_LOOPBACK),
                .sin_port = htons(10000)
        };
        struct sockaddr_in addr2 = { };
        char c = 0;
        struct iovec iov1 = { "", 1 };
        struct iovec iov2 = { &c, 1 };
        const struct msghdr msg1 = {
                .msg_iov = &iov1,
                .msg_iovlen = 1,
                .msg_name = &addr1,
                .msg_namelen = sizeof(addr1)
        };
        struct msghdr msg2 = {
                .msg_iov = &iov2,
                .msg_iovlen = 1,
                .msg_name = &addr2,
                .msg_namelen = sizeof(addr2)
        };
        if (bind(fd2, (struct sockaddr *) &addr1, sizeof(addr1)))
                return 1;
        if (sendmsg(fd1, &msg1, 0) != 1 || recvmsg(fd2, &msg2, 0) != 1)
                return 1;
        if (connect(fd1, (struct sockaddr *) &addr1, sizeof(addr1)))
                return 1;
        if (send(fd1, "", 1, 0) != 1 || recv(fd2, &c, 1, 0) != 1)
                return 1;
        return 0;
}
----------
