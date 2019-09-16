Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 582D3B3719
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 11:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729991AbfIPJ06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 05:26:58 -0400
Received: from www62.your-server.de ([213.133.104.62]:34176 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725850AbfIPJ06 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 05:26:58 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1i9nHb-0007n2-0A; Mon, 16 Sep 2019 11:26:55 +0200
Received: from [2a02:120b:2c12:c120:71a0:62dd:894c:fd0e] (helo=pc-66.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1i9nHa-0008Up-OB; Mon, 16 Sep 2019 11:26:54 +0200
Subject: Re: [PATCH bpf] bpf: respect CAP_IPC_LOCK in RLIMIT_MEMLOCK check
To:     Christian Barcenas <christian@cbarcenas.com>,
        Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, bpf@vger.kernel.org
References: <20190911181816.89874-1-christian@cbarcenas.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <678ba696-4b20-5f06-7c4f-ec68a9229620@iogearbox.net>
Date:   Mon, 16 Sep 2019 11:26:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190911181816.89874-1-christian@cbarcenas.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25573/Sun Sep 15 10:22:02 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/11/19 8:18 PM, Christian Barcenas wrote:
> A process can lock memory addresses into physical RAM explicitly
> (via mlock, mlockall, shmctl, etc.) or implicitly (via VFIO,
> perf ring-buffers, bpf maps, etc.), subject to RLIMIT_MEMLOCK limits.
> 
> CAP_IPC_LOCK allows a process to exceed these limits, and throughout
> the kernel this capability is checked before allowing/denying an attempt
> to lock memory regions into RAM.
> 
> Because bpf locks its programs and maps into RAM, it should respect
> CAP_IPC_LOCK. Previously, bpf would return EPERM when RLIMIT_MEMLOCK was
> exceeded by a privileged process, which is contrary to documented
> RLIMIT_MEMLOCK+CAP_IPC_LOCK behavior.

Do you have a link/pointer where this is /clearly/ documented?

Uapi header is not overly clear ...

include/uapi/linux/capability.h says:

   /* Allow locking of shared memory segments */
   /* Allow mlock and mlockall (which doesn't really have anything to do
      with IPC) */

   #define CAP_IPC_LOCK         14

   [...]

   /* Override resource limits. Set resource limits. */
   /* Override quota limits. */
   /* Override reserved space on ext2 filesystem */
   /* Modify data journaling mode on ext3 filesystem (uses journaling
      resources) */
   /* NOTE: ext2 honors fsuid when checking for resource overrides, so
      you can override using fsuid too */
   /* Override size restrictions on IPC message queues */
   /* Allow more than 64hz interrupts from the real-time clock */
   /* Override max number of consoles on console allocation */
   /* Override max number of keymaps */

   #define CAP_SYS_RESOURCE     24

... but my best guess is you are referring to `man 2 mlock`:

    Limits and permissions

        In Linux 2.6.8 and earlier, a process must be privileged (CAP_IPC_LOCK)
        in order to lock memory and the RLIMIT_MEMLOCK soft resource limit defines
        a limit on how much memory the process may lock.

        Since  Linux  2.6.9, no limits are placed on the amount of memory that a
        privileged process can lock and the RLIMIT_MEMLOCK soft resource limit
        instead defines a limit on how much memory an unprivileged process may lock.

Thanks,
Daniel
