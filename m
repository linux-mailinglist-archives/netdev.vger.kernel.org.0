Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B01129E2CA
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 03:38:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726732AbgJ2CWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 22:22:45 -0400
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:56692 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726694AbgJ2CWd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 22:22:33 -0400
Received: from [192.168.188.14] (unknown [106.75.220.2])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 025305C17FF;
        Thu, 29 Oct 2020 10:22:05 +0800 (CST)
Subject: [resend] Solution for the problem conntrack in tc subsystem
References: <7821f3ae-0e71-0d8b-5ef9-81da69ac29dc@ucloud.cn>
To:     Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
From:   wenxu <wenxu@ucloud.cn>
X-Forwarded-Message-Id: <7821f3ae-0e71-0d8b-5ef9-81da69ac29dc@ucloud.cn>
Message-ID: <435e4756-f36a-f0f5-0ac5-45bd5cacaff2@ucloud.cn>
Date:   Thu, 29 Oct 2020 10:22:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <7821f3ae-0e71-0d8b-5ef9-81da69ac29dc@ucloud.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZH0tKSkpOSk4fHR5NVkpNS0hCSENKSU1KSE9VGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hNSlVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PzY6Ngw5Vj5LP08LQgoZMC0S
        KSswCzxVSlVKTUtIQkhDSklNSEtKVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpLTVVM
        TlVJSUtVSVlXWQgBWUFJTU1MNwY+
X-HM-Tid: 0a75722989122087kuqy025305c17ff
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi,


Currently kernel tc subsystem can do conntrack things in cat_ct. But there is a problem need

to fix.  For several fragment packets handle in act_ct.  The tcf_ct_handle_fragments will defrag

the packets to a big one. But the after action will redirect mirror to a device which maybe lead

the reassembly big packet over the mtu of target device.


The proposal "net/sched: act_mirred: fix fragment the packet after defrag in act_ct"

http://patchwork.ozlabs.org/project/netdev/patch/1593485646-14989-1-git-send-email-wenxu@ucloud.cn/

is not been accepted.


another proposal "net/sched: add act_ct_output support"

http://patchwork.ozlabs.org/project/netdev/patch/1598335663-26503-1-git-send-email-wenxu@ucloud.cn/

is also not a good solution. There are some duplicate codes for this and act_mirred.


Something other proposal like add the  act_fragment also can't be work.  The fragment will make

The big packet to several ones and can't be handle in the tc pipe. And also this is not friendly for

user to explicitly add action for fragment.

Only do gso for the reassembly big packet is also can't fix all the case such for icmp packet.


So there are some proper solution for this problem. In the Internet we can't avoid the fragment packets.



BR

wenxu








