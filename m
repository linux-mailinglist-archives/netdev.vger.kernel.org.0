Return-Path: <netdev+bounces-3359-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B7B1E706A3B
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 15:54:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 58A701C20F59
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 13:54:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F4192C74D;
	Wed, 17 May 2023 13:54:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03AC818B16;
	Wed, 17 May 2023 13:54:32 +0000 (UTC)
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AD6B98;
	Wed, 17 May 2023 06:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
	bh=3N7Ako0hYBSM2yG/5rBv24VQVMmPl5YZsnA8/YlN3Dc=; b=ZuWRNi8IpKmWOhHrRH6vsvVK6W
	E2vb9VI8kggsNyaJMZv4O0gq1mXRIc+Wxrp5GwcpK8tfwQ20GquqB6I7F8mNu0BZzAppJPXB/KxxG
	4Z4W0zHlRvgEdNRd+I4KR3CBCnvXurxfeClBhoNcYfUWewdiABRPxCypynzucTp/jDPYHFPwZM4+s
	2UYRhdHf38pk/qw/einZhOKjT+qZXoofT1zbZcbGYteDayd9YZGkrH5iat3+01GNMDJ7HrS8d3PT3
	I/g76hwXg/L/z4CNbn4a5HCgThGfpaHSxt57nyz8YxJ2VemQV+wef8wrRSWFouls9zRO41/j1gj9w
	0MRWi69g==;
Received: from sslproxy06.your-server.de ([78.46.172.3])
	by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <daniel@iogearbox.net>)
	id 1pzHbf-000DCV-VA; Wed, 17 May 2023 15:54:19 +0200
Received: from [85.1.206.226] (helo=linux.home)
	by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <daniel@iogearbox.net>)
	id 1pzHbf-000Raa-Cj; Wed, 17 May 2023 15:54:19 +0200
Subject: Re: [PATCH bpf v8 00/13] bpf sockmap fixes
To: John Fastabend <john.fastabend@gmail.com>, jakub@cloudflare.com
Cc: bpf@vger.kernel.org, netdev@vger.kernel.org, edumazet@google.com,
 ast@kernel.org, andrii@kernel.org, will@isovalent.com
References: <20230517052244.294755-1-john.fastabend@gmail.com>
From: Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <fba80558-3786-0fc4-b972-a6c2ac49ebce@iogearbox.net>
Date: Wed, 17 May 2023 15:54:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230517052244.294755-1-john.fastabend@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.8/26910/Wed May 17 09:22:55 2023)
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/17/23 7:22 AM, John Fastabend wrote:
> This v8 iteration adds another fix suggested by Jakub to always
> check the enable bit is set before rescheduling to avoid trying
> to reschedule backlog queue handler while trying to tear down
> a socket. Also cleaned up one of the tests as suggested by Jakub
> to avoid creating unused pair of sockets.
[...]
> v8: Only schedule backlog when still enabled and cleanup test
>      to not create unused sockets.

Looks like this needs a v9 :( The series does not apply to bpf tree,
see here:

[...]
Cmd('git') failed due to: exit code(128)
   cmdline: git am --3way
   stdout: 'Applying: bpf: sockmap, pass skb ownership through read_skb
Applying: bpf: sockmap, convert schedule_work into delayed_work
Applying: bpf: sockmap, reschedule is now done through backlog
Applying: bpf: sockmap, improved check for empty queue
Applying: bpf: sockmap, handle fin correctly
Applying: bpf: sockmap, TCP data stall on recv before accept
Applying: bpf: sockmap, wake up polling after data copy
Applying: bpf: sockmap, incorrectly handling copied_seq
Applying: bpf: sockmap, pull socket helpers out of listen test for general use
Using index info to reconstruct a base tree...
M	tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
Falling back to patching base and 3-way merge...
Auto-merging tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
CONFLICT (content): Merge conflict in tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
Patch failed at 0009 bpf: sockmap, pull socket helpers out of listen test for general use
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".'
   stderr: 'error: Failed to merge in the changes.
hint: Use 'git am --show-current-patch=diff' to see the failed patch'

