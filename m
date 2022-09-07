Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F26A5AFBA3
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 07:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbiIGFSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 01:18:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiIGFSo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 01:18:44 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40B319C8D9;
        Tue,  6 Sep 2022 22:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662527924; x=1694063924;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ramvOUtx8XnHZKzNv1q3piGUCQeF1ndHFRzBHtiRrN8=;
  b=XBDz7rhh1E5PVC1p3wV/K/zqk2IUKiZwVVuYmQZCkJnXIn31l6uR7v+w
   smBzqMnGZLLHeAlySRNgHfLFSHJkuaz7sp5oVUdW3AJWW1tZszkPfukda
   rBt3XZmY1BX7pYP+yJF0To3xHgSDrqCowHotR3tf0NyKPB6u5Tr+OeOsO
   NXq+cXewilfag1FBoKou+ce1gw6XTZ63GnPDdlzPCPZ7U4osVRp+r3rxz
   KA6V57hiE7BagW3l3jKpBXtLsPMAV75AIDmPQCPluGGbND2dbBAUVeZde
   HVvAfJmtxeRZwLKh2lx4/cEfG2oG0JnGoH8PFlVzF+lgIcLmXz2MkHgGz
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10462"; a="360728973"
X-IronPort-AV: E=Sophos;i="5.93,295,1654585200"; 
   d="scan'208";a="360728973"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2022 22:18:43 -0700
X-IronPort-AV: E=Sophos;i="5.93,295,1654585200"; 
   d="scan'208";a="644464015"
Received: from jiebi-mobl1.ccr.corp.intel.com (HELO jiezho4x-mobl1.ccr.corp.intel.com) ([10.255.30.104])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2022 22:18:39 -0700
From:   Jie2x Zhou <jie2x.zhou@intel.com>
To:     jie2x.zhou@intel.com, andrii@kernel.org, mykolal@fb.com,
        ast@kernel.org, daniel@iogearbox.net, martin.lau@linux.dev,
        davem@davemloft.net, kuba@kernel.org, hawk@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Philip Li <philip.li@intel.com>
Subject: test ./tools/testing/selftests/bpf/test_offload.py failed
Date:   Wed,  7 Sep 2022 13:16:57 +0800
Message-Id: <20220907051657.55597-1-jie2x.zhou@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi,

I try to know why output following error?
I found that "disable_ifindex" file do not set read function, so return -EINVAL when do read.
Is it a bug in test_offload.py?

test output:
 selftests: bpf: test_offload.py
 Test destruction of generic XDP...
......
     raise Exception("Command failed: %s\n%s" % (proc.args, stderr))
 Exception: Command failed: cat /sys/kernel/debug/netdevsim/netdevsim0//ports/0/dev/hwstats/l3/disable_ifindex
 
 cat: /sys/kernel/debug/netdevsim/netdevsim0//ports/0/dev/hwstats/l3/disable_ifindex: Invalid argument
 not ok 20 selftests: bpf: test_offload.py # exit=1

source code:
In drivers/net/netdevsim/hwstats.c:
define NSIM_DEV_HWSTATS_FOPS(ACTION, TYPE)                     \
        {                                                       \
                .fops = {                                       \
                        .open = simple_open,                    \
                        .write = nsim_dev_hwstats_do_write,     \
                        .llseek = generic_file_llseek,          \
                        .owner = THIS_MODULE,                   \
                },                                              \
                .action = ACTION,                               \
                .type = TYPE,                                   \
        }

static const struct nsim_dev_hwstats_fops nsim_dev_hwstats_l3_disable_fops =
        NSIM_DEV_HWSTATS_FOPS(NSIM_DEV_HWSTATS_DO_DISABLE,
                              NETDEV_OFFLOAD_XSTATS_TYPE_L3);

        debugfs_create_file("disable_ifindex", 0600, hwstats->l3_ddir, hwstats,
                            &nsim_dev_hwstats_l3_disable_fops.fops);

In fs/read_write.c:
ssize_t vfs_read(struct file *file, char __user *buf, size_t count, loff_t *pos)
{
......
        if (file->f_op->read)
                ret = file->f_op->read(file, buf, count, pos);
        else if (file->f_op->read_iter)
                ret = new_sync_read(file, buf, count, pos);
        else
                ret = -EINVAL;
......
}

best regards,
