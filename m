Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FFF21552A6
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 07:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbgBGG7p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 01:59:45 -0500
Received: from mout.kundenserver.de ([217.72.192.75]:46907 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgBGG7p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Feb 2020 01:59:45 -0500
Received: from [192.168.0.101] ([149.172.188.111]) by mrelayeu.kundenserver.de
 (mreue106 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1N2mS2-1jetSV3Rhk-0135wY for <netdev@vger.kernel.org>; Fri, 07 Feb 2020
 07:59:43 +0100
To:     netdev@vger.kernel.org
From:   Martin Rosenau <martin@rosenau-ka.de>
Subject: Feature: "misc" pseudo protocol family
Message-ID: <903eed0a-b0c8-f351-cbc1-135ddaf3adcc@rosenau-ka.de>
Date:   Fri, 7 Feb 2020 07:59:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: de-DE
X-Provags-ID: V03:K1:QHYZjgLmIcuwiVzhwOFzjhoQ/TV8X/+9LzWLm/xzC13biiaH/vL
 8kM1wAMhx0AYy9C84b9fSrVNiCt4j3RsPYcfmAglIZgDyidi/zdujlNIiT4C55r95UNhNn8
 inz5YWC3JS9s7Nazo6C1g09C7B8sqmWK+xNCqFHsa936QbNL8pzINlFv0nIh4RC3uF/OeyP
 t1JjZX4FrhBbfvt67Je0Q==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:NIqE0jlO4Tg=:N1c3HISLkGvcjhF+nDGrOT
 CRioQGNt85FIw3aqYfvzkKnC/ESsIgHNUQPBhNu2JLC27GsFfuY54em/Nb/6zC7Xa9RzGsE02
 /3PWlVA7emGXXTjJCaAsh7UoFj0xt+R0nXJU/Ltvtzp2MUvRSz3NBTlynwGGyyWhiuRsJ5OeK
 ANTJ74MYQ2ocbueD7CTOhsXQ2Hiqa9fnFwMT46VuXfBSxT3RUBNzHyBCviIlsc5ZpNPCc/MfG
 a4kl3o+lDwVMYIEElvbK3y81ntKBMw1Q/mHJgtCCKlNNdagZUAxeHYxJAt6ktmiib5/puxfSy
 6EFsStrUSsg5bgk0v8qbzKyc2Oa4G9pAVFp1fYoej4c8kr9IdWM5+88SQ95cjJN8+++Ln82E4
 zNS3PLE3WomnkWjx5nhIbh3xFyp9caX5J89uN93Jpc2siDjPXLUXpNMMxFtu6NXi574VJT/bO
 eSE3nNCVqLZ0YlgHrrKL05QwYQgT5QJo13l1UWZPZ4Z8q7qeEGMGjL0SkjsGALqIQPKnEZBoS
 0fdvCQL5hMvieYYpixdsyVGiGGCPhJUUb5BtR8NS90lH00L5+KdOu7kZwkOWA7DfbevkLUjtL
 ymuDbTqv3kSTaIxfMbcr2MxhQfeVSe+dhq1RXtmpIitkspKOeedLws3OpjNqbS9ULGcDVC39i
 yxWm2Jvqihk41uSvYZIPTzp8tVuFswlIn31EyN1Fv+VbUeIdpYMIewdtOomvmROCJK2jKHe2/
 kv/bjXKU1Zdab9jR8pIZM6ZBezZeSI+ZzYXIpmMOhaBp/c/ELD0mtE6G3WUzKgkcxXfJ7q9Px
 pLq6BVYW7PYwqFyLS/6pdh/PJ4ep3A6iIYp+kmVMXRMNalKfK0MqBQlauwtlYUyui9muSKT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Unlike other OSs, Linux is often used to run experimental software. In 
my case it was an uncommon network protocol that I wanted to implement 
in a kernel module.

Unfortunately, it is not possible to add additional "AF_xxx" protocols 
to Linux without re-compiling the kernel because there are arrays with 
the size "AF_MAX" so Linux does not allow "AF_xxx" constants above "AF_MAX".

Simply increasing "AF_MAX" and leaving a range free for experimental 
protocols might be a solution; however, in this case the constants 
"AF_xxx" would have a different meaning on different computers, so 
programs using such protocols are not interchangable between computers.

To solve this, I'd like to propose a "protocol multiplexer" using 
string-based protocol IDs instead of integers intended for experimental 
or uncommon protocols:

Instead of doing:

   mySocket = socket(PF_INET3, SOCK_STREAM, IPPROTO_TCP);

... you would do:

   mySocket = socket(PF_MISC, SOCK_DGRAM, 0);

   protocolId = ioctl(mySocket, SIOCPFMISCQUERYNAME, "TCP_IPV3");

   close(mySocket);

   mySocket = socket(PF_MISC, SOCK_STREAM, protocolId);

A loadable kernel module implementing such a protocol would register 
itself using its string ID at the "PF_MISC" implementation instead of 
using "sock_register()" and an "AF_xxx" constant.

The actual PF_MISC implementation can be done in a kernel module; 
however, the change of the AF_MAX constant and the definition of PF_MISC 
has to be done in the kernel itself.

I'm new to kernel development, so I apologize if posting this message 
here was not a good idea.

I was already posting this proposal to the Linux kernel bugzilla; there 
I was told to post this idea to this mailing list.

Thanks for reading

Martin


