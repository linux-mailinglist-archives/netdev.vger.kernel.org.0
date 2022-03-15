Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BBC74DA00F
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 17:29:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350061AbiCOQaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 12:30:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350010AbiCOQap (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 12:30:45 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80D4A56C3E;
        Tue, 15 Mar 2022 09:29:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647361773; x=1678897773;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5bWJ1aLHhnxNHrTHdW/lDQbheo4ws+MyK4EncLb5sbM=;
  b=KvA5YrFx2G3CWHBYBaMaGVg4YJiB5keas9t0cFEsg/KYBk8nj5f7PlT2
   pTCIQ7j8m+XRM8oC835CmeZM8gnjMyO1r3U3VP4MXdtk/ZQTA0iNoxp1l
   T5P+S5Gi+cpz2HQZCgmL+Cf7Kbj6MFDvl7QK6gMsTMXOQKiP/6+FC/OH9
   jsD1BM6kQdHqPlbqg1Qwr8skEi7CKPhYpsq0+SSM5itpK5fwgEwahJF0I
   WFPGzUQ4GkpC1fxAoCGRxN3POkrJ9irLvVlh0b39sqv/y8zfDjXbmMmcQ
   tVBVg8VveMqafE/jyMWbVJ/WTR2MB2DErzTgbUDHzicxDL2OXBjJ1qTCR
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="281125062"
X-IronPort-AV: E=Sophos;i="5.90,184,1643702400"; 
   d="scan'208";a="281125062"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2022 09:29:19 -0700
X-IronPort-AV: E=Sophos;i="5.90,184,1643702400"; 
   d="scan'208";a="690255507"
Received: from lepple-mobl1.ger.corp.intel.com (HELO [10.252.56.30]) ([10.252.56.30])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2022 09:29:14 -0700
Message-ID: <daf2136a-d6ff-558c-e9bb-c7a45dd1c43f@linux.intel.com>
Date:   Tue, 15 Mar 2022 18:29:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH bpf-next v2 03/28] HID: hook up with bpf
Content-Language: en-US
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>
Cc:     linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org
References: <20220304172852.274126-1-benjamin.tissoires@redhat.com>
 <20220304172852.274126-4-benjamin.tissoires@redhat.com>
From:   Tero Kristo <tero.kristo@linux.intel.com>
In-Reply-To: <20220304172852.274126-4-benjamin.tissoires@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Benjamin,

On 04/03/2022 19:28, Benjamin Tissoires wrote:
> Now that BPF can be compatible with HID, add the capability into HID.
> drivers/hid/hid-bpf.c takes care of the glue between bpf and HID, and
> hid-core can then inject any incoming event from the device into a BPF
> program to filter/analyze it.
>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>
> ---
>
> changes in v2:
> - split the series by bpf/libbpf/hid/selftests and samples
> - addressed review comments from v1
> ---
>   drivers/hid/Makefile   |   1 +
>   drivers/hid/hid-bpf.c  | 157 +++++++++++++++++++++++++++++++++++++++++
>   drivers/hid/hid-core.c |  21 +++++-
>   include/linux/hid.h    |  11 +++
>   4 files changed, 187 insertions(+), 3 deletions(-)
>   create mode 100644 drivers/hid/hid-bpf.c
>
> diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
> index 6d3e630e81af..08d2d7619937 100644
> --- a/drivers/hid/Makefile
> +++ b/drivers/hid/Makefile
> @@ -4,6 +4,7 @@
>   #
>   hid-y			:= hid-core.o hid-input.o hid-quirks.o
>   hid-$(CONFIG_DEBUG_FS)		+= hid-debug.o
> +hid-$(CONFIG_BPF)		+= hid-bpf.o
>   
>   obj-$(CONFIG_HID)		+= hid.o
>   obj-$(CONFIG_UHID)		+= uhid.o
> diff --git a/drivers/hid/hid-bpf.c b/drivers/hid/hid-bpf.c
> new file mode 100644
> index 000000000000..8120e598de9f
> --- /dev/null
> +++ b/drivers/hid/hid-bpf.c
> @@ -0,0 +1,157 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + *  BPF in HID support for Linux
> + *
> + *  Copyright (c) 2022 Benjamin Tissoires
> + */
> +
> +#include <linux/filter.h>
> +#include <linux/mutex.h>
> +#include <linux/slab.h>
> +
> +#include <uapi/linux/bpf_hid.h>
> +#include <linux/hid.h>
> +
> +static int __hid_bpf_match_sysfs(struct device *dev, const void *data)
> +{
> +	struct kernfs_node *kn = dev->kobj.sd;
> +	struct kernfs_node *uevent_kn;
> +
> +	uevent_kn = kernfs_find_and_get_ns(kn, "uevent", NULL);
> +
> +	return uevent_kn == data;
> +}
> +
> +static struct hid_device *hid_bpf_fd_to_hdev(int fd)
> +{
> +	struct device *dev;
> +	struct hid_device *hdev;
> +	struct fd f = fdget(fd);
> +	struct inode *inode;
> +	struct kernfs_node *node;
> +
> +	if (!f.file) {
> +		hdev = ERR_PTR(-EBADF);
> +		goto out;
> +	}
> +
> +	inode = file_inode(f.file);
> +	node = inode->i_private;
> +
> +	dev = bus_find_device(&hid_bus_type, NULL, node, __hid_bpf_match_sysfs);
> +
> +	if (dev)
> +		hdev = to_hid_device(dev);
> +	else
> +		hdev = ERR_PTR(-EINVAL);
> +
> + out:
> +	fdput(f);
> +	return hdev;
> +}
> +
> +static int hid_bpf_link_attach(struct hid_device *hdev, enum bpf_hid_attach_type type)
> +{
> +	int err = 0;
> +
> +	switch (type) {
> +	case BPF_HID_ATTACH_DEVICE_EVENT:
> +		if (!hdev->bpf.ctx) {
> +			hdev->bpf.ctx = bpf_hid_allocate_ctx(hdev, HID_BPF_MAX_BUFFER_SIZE);
> +			if (IS_ERR(hdev->bpf.ctx)) {
> +				err = PTR_ERR(hdev->bpf.ctx);
> +				hdev->bpf.ctx = NULL;
> +			}
> +		}
> +		break;
> +	default:
> +		/* do nothing */

These cause following error:


   CC      drivers/hid/hid-bpf.o
drivers/hid/hid-bpf.c: In function ‘hid_bpf_link_attach’:
drivers/hid/hid-bpf.c:88:2: error: label at end of compound statement
    88 |  default:
       |  ^~~~~~~
drivers/hid/hid-bpf.c: In function ‘hid_bpf_link_attached’:
drivers/hid/hid-bpf.c:101:2: error: label at end of compound statement
   101 |  default:
       |  ^~~~~~~
drivers/hid/hid-bpf.c: In function ‘hid_bpf_array_detached’:
drivers/hid/hid-bpf.c:116:2: error: label at end of compound statement
   116 |  default:
       |  ^~~~~~~
make[2]: *** [scripts/Makefile.build:288: drivers/hid/hid-bpf.o] Error 1
make[1]: *** [scripts/Makefile.build:550: drivers/hid] Error 2
make[1]: *** Waiting for unfinished jobs....
make: *** [Makefile:1831: drivers] Error 2

To fix that, you need to add a break statement at end:

default:

     /* do nothing */

     break;

Same for couple of other occurrences in the file.

-Tero


