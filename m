Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45B10596504
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 23:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237808AbiHPVzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 17:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237628AbiHPVzo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 17:55:44 -0400
Received: from forward503j.mail.yandex.net (forward503j.mail.yandex.net [5.45.198.239])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ED8E8671A
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 14:55:43 -0700 (PDT)
Received: from sas1-384d3eaa6677.qloud-c.yandex.net (sas1-384d3eaa6677.qloud-c.yandex.net [IPv6:2a02:6b8:c14:3a29:0:640:384d:3eaa])
        by forward503j.mail.yandex.net (Yandex) with ESMTP id 7C5F81DAEF14;
        Wed, 17 Aug 2022 00:55:40 +0300 (MSK)
Received: by sas1-384d3eaa6677.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id 1P0MvZ0twV-tdimrCOo;
        Wed, 17 Aug 2022 00:55:39 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ya.ru; s=mail; t=1660686939;
        bh=aaMhtK7KXMY88tvSbe1366mWAeFhkuU/WIqhipI8glY=;
        h=Cc:References:Date:Message-ID:In-Reply-To:From:To:Subject;
        b=jKDvSDB608qanO/jtdqDBZFGuL90x6n9RdntcJ4FRjW5jdGmUPfBS3IpPQJfSbDqI
         +Js9txN/Whx8c7/HmphZv9lgybPFSIpuUHItKazoySLJ7Wh+SAHqGJBNyNypjL44Pa
         P1ghmGuo4CQPagOp/Mzyq1L3EYSe668kwvmMI3z8=
Authentication-Results: sas1-384d3eaa6677.qloud-c.yandex.net; dkim=pass header.i=@ya.ru
Subject: Re: [PATCH v2 0/2] unix: Add ioctl(SIOCUNIXGRABFDS) to grab files of
 receive queue skbs
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        davem@davemloft.net, edumazet@google.com
References: <0b07a55f-0713-7ba4-9b6b-88bc8cc6f1f5@ya.ru>
 <YvvXCWYpVCOxZeEt@ZenIV>
From:   Kirill Tkhai <tkhai@ya.ru>
Message-ID: <f493bd2d-f51a-9f4a-4b06-93404f63cce2@ya.ru>
Date:   Wed, 17 Aug 2022 00:55:38 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YvvXCWYpVCOxZeEt@ZenIV>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16.08.2022 20:42, Al Viro wrote:
> On Tue, Aug 16, 2022 at 12:13:16AM +0300, Kirill Tkhai wrote:
>> When a fd owning a counter of some critical resource, say, of a mount,
>> it's impossible to umount that mount and disconnect related block device.
>> That fd may be contained in some unix socket receive queue skb.
>>
>> Despite we have an interface for detecting such the sockets queues
>> (/proc/[PID]/fdinfo/[fd] shows non-zero scm_fds count if so) and
>> it's possible to kill that process to release the counter, the problem is
>> that there may be several processes, and it's not a good thing to kill
>> each of them.
>>
>> This patch adds a simple interface to grab files from receive queue,
>> so the caller may analyze them, and even do that recursively, if grabbed
>> file is unix socket itself. So, the described above problem may be solved
>> by this ioctl() in pair with pidfd_getfd().
>>
>> Note, that the existing recvmsg(,,MSG_PEEK) is not suitable for that
>> purpose, since it modifies peek offset inside socket, and this results
>> in a problem in case of examined process uses peek offset itself.
>> Additional ptrace freezing of that task plus ioctl(SO_PEEK_OFF) won't help
>> too, since that socket may relate to several tasks, and there is no
>> reliable and non-racy way to detect that. Also, if the caller of such
>> trick will die, the examined task will remain frozen forever. The new
>> suggested ioctl(SIOCUNIXGRABFDS) does not have such problems.
>>
>> The realization of ioctl(SIOCUNIXGRABFDS) is pretty simple. The only
>> interesting thing is protocol with userspace. Firstly, we let userspace
>> to know the number of all files in receive queue skbs. Then we receive
>> fds one by one starting from requested offset. We return number of
>> received fds if there is a successfully received fd, and this number
>> may be less in case of error or desired fds number lack. Userspace
>> may detect that situations by comparison of returned value and
>> out.nr_all minus in.nr_skip. Looking over different variant this one
>> looks the best for me (I considered returning error in case of error
>> and there is a received fd. Also I considered returning number of
>> received files as one more member in struct unix_ioc_grab_fds).
> 
> IMO it's a bad interface.  Take a good look at the logics in scan_children();
> TCP_LISTEN side is there for reason.  And your magical ioctl won't help
> with that case.

Good catch, thank you! I'll extend it to handle that case too. And your words
bring to mind that fdinfo's scm_fds is also wrong for TCP_LISTEN sockets.
I've sent separate patch with you CC'ed to fix that problem.

Kirill
