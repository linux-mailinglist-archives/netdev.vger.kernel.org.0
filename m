Return-Path: <netdev+bounces-7035-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A2B667195BF
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 10:38:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 601B42816D2
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 08:38:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88B72C120;
	Thu,  1 Jun 2023 08:38:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E48AA923
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 08:38:10 +0000 (UTC)
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C12819B;
	Thu,  1 Jun 2023 01:38:07 -0700 (PDT)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0Vk3n4AU_1685608664;
Received: from 30.221.128.127(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0Vk3n4AU_1685608664)
          by smtp.aliyun-inc.com;
          Thu, 01 Jun 2023 16:38:04 +0800
Message-ID: <9b4d26c9-bc63-3491-c118-60a345667583@linux.alibaba.com>
Date: Thu, 1 Jun 2023 16:37:42 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH net 2/2] net/smc: Don't use RMBs not mapped to new link in
 SMCRv2 ADD LINK
To: Wenjia Zhang <wenjia@linux.ibm.com>, kgraul@linux.ibm.com,
 jaka@linux.ibm.com, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com
Cc: linux-s390@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <1685101741-74826-1-git-send-email-guwen@linux.alibaba.com>
 <1685101741-74826-3-git-send-email-guwen@linux.alibaba.com>
 <f134294c-2919-6069-d362-87a84c846690@linux.ibm.com>
 <34e6b564-a658-4461-ebec-f53dd80a9125@linux.alibaba.com>
 <f309d525-7e12-ee81-8d59-ad07f94f9e9d@linux.ibm.com>
From: Wen Gu <guwen@linux.alibaba.com>
In-Reply-To: <f309d525-7e12-ee81-8d59-ad07f94f9e9d@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.0 required=5.0 tests=BAYES_00,
	ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 2023/5/31 04:34, Wenjia Zhang wrote:
> 
> 
> 
> Hi Wen,
> 
> Sorry for the late answer because of the public holiday here!
> 
> I really like the test scenario, thank you for the elaboration and the fixes!
> They look good to me.
> 
> Why I asked that was that the first patch looked very reasonable, but I was wondering why I didn't meet any problem with 
> that before ;-) and if it would trigger some problem during processing the SMCRv1 ADD Link Continuation Messages. After 
> checking the code again, I don't think there would be any problem with the patch, because in the case of processing the 
> SMCRv1 ADD Link Continuation Messages, it's about the same RMB.
> 
> Hi @Paolo, I would appreciate it if you could give us more time to review and test the patches. Because we have to make 
> sure that they can work on our platform (s390) without problem, not only on x86.
> 
> Thanks
> Wenjia
> 
> 

Inspired by your comments, I check the SMCRv1 and find it has the similar issue in smc_llc_add_link_cont().
The cause and way to reproduce it are similar to the issue in SMCRv2. I will fix this as well.

[  361.813390] BUG: kernel NULL pointer dereference, address: 0000000000000014
[  361.814121] #PF: supervisor read access in kernel mode
[  361.814646] #PF: error_code(0x0000) - not-present page
[  361.815160] PGD 0 P4D 0
[  361.815431] Oops: 0000 [#1] PREEMPT SMP PTI
[  361.815866] CPU: 5 PID: 48 Comm: kworker/5:0 Kdump: loaded Tainted: G        W   E      6.4.0-rc3+ #49
[  361.817952] Workqueue: events smc_llc_add_link_work [smc]
[  361.818527] RIP: 0010:smc_llc_add_link_cont+0x160/0x270 [smc]
[  361.820973] RSP: 0018:ffffa737801d3d50 EFLAGS: 00010286
[  361.821517] RAX: ffff964f82144000 RBX: ffffa737801d3dd8 RCX: 0000000000000000
[  361.822246] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff964f81370c30
[  361.822957] RBP: ffffa737801d3dd4 R08: ffff964f81370000 R09: ffffa737801d3db0
[  361.823678] R10: 0000000000000001 R11: 0000000000000060 R12: ffff964f82e70000
[  361.824409] R13: ffff964f81370c38 R14: ffffa737801d3dd3 R15: 0000000000000001
[  361.825119] FS:  0000000000000000(0000) GS:ffff9652bfd40000(0000) knlGS:0000000000000000
[  361.825934] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  361.826515] CR2: 0000000000000014 CR3: 000000008fa20004 CR4: 00000000003706e0
[  361.827251] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  361.827989] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  361.828712] Call Trace:
[  361.828964]  <TASK>
[  361.829182]  smc_llc_srv_rkey_exchange+0xa7/0x190 [smc]
[  361.829726]  smc_llc_srv_add_link+0x3ae/0x5a0 [smc]
[  361.830246]  smc_llc_add_link_work+0xb8/0x140 [smc]
[  361.830752]  process_one_work+0x1e5/0x3f0
[  361.831173]  worker_thread+0x4d/0x2f0
[  361.831531]  ? __pfx_worker_thread+0x10/0x10
[  361.831925]  kthread+0xe5/0x120
[  361.832239]  ? __pfx_kthread+0x10/0x10
[  361.832630]  ret_from_fork+0x2c/0x50
[  361.833004]  </TASK>
[  361.833236] Modules linked in: binfmt_misc(E) smc_diag(E) smc(E) rfkill(E) intel_rapl_msr(E) intel_rapl_common(E) 
mousedev(E) psmouse(E) i2c_piix4(E) pcspkr(E) ip_tables(E) mlx5_ib(E) ib_uverbs(E) ib_core(E) cirrus(E) ata_generic(E) 
drm_shmem_helper(E) drm_kms_helper(E) syscopyarea(E) ata_piix(E) sysfillrect(E) crct10dif_pclmul(E) sysimgblt(E) 
mlx5_core(E) crc32_pclmul(E) drm(E) virtio_net(E) mlxfw(E) crc32c_intel(E) ghash_clmulni_intel(E) net_failover(E) 
psample(E) i2c_core(E) failover(E) pci_hyperv_intf(E) serio_raw(E) libata(E) dm_mirror(E) dm_region_hash(E) dm_log(E) 
dm_mod(E)
[  361.839180] CR2: 0000000000000014

Thanks,
Wen Gu

