Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64105155DD8
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 19:19:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727631AbgBGST4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 13:19:56 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52528 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727129AbgBGST4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Feb 2020 13:19:56 -0500
Received: from 2606-a000-111b-43ee-0000-0000-0000-115f.inf6.spectrum.com ([2606:a000:111b:43ee::115f] helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1j08ED-0008B9-6L; Fri, 07 Feb 2020 13:19:50 -0500
Date:   Fri, 7 Feb 2020 13:19:44 -0500
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net] drop_monitor: Do not cancel uninitialized work item
Message-ID: <20200207181944.GA23258@hmswarspite.think-freely.org>
References: <20200207172928.129123-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200207172928.129123-1-idosch@idosch.org>
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 07, 2020 at 07:29:28PM +0200, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> Drop monitor uses a work item that takes care of constructing and
> sending netlink notifications to user space. In case drop monitor never
> started to monitor, then the work item is uninitialized and not
> associated with a function.
> 
> Therefore, a stop command from user space results in canceling an
> uninitialized work item which leads to the following warning [1].
> 
> Fix this by not processing a stop command if drop monitor is not
> currently monitoring.
> 
> [1]
> [   31.735402] ------------[ cut here ]------------
> [   31.736470] WARNING: CPU: 0 PID: 143 at kernel/workqueue.c:3032 __flush_work+0x89f/0x9f0
> ...
> [   31.738120] CPU: 0 PID: 143 Comm: dwdump Not tainted 5.5.0-custom-09491-g16d4077796b8 #727
> [   31.741968] RIP: 0010:__flush_work+0x89f/0x9f0
> ...
> [   31.760526] Call Trace:
> [   31.771689]  __cancel_work_timer+0x2a6/0x3b0
> [   31.776809]  net_dm_cmd_trace+0x300/0xef0
> [   31.777549]  genl_rcv_msg+0x5c6/0xd50
> [   31.781005]  netlink_rcv_skb+0x13b/0x3a0
> [   31.784114]  genl_rcv+0x29/0x40
> [   31.784720]  netlink_unicast+0x49f/0x6a0
> [   31.787148]  netlink_sendmsg+0x7cf/0xc80
> [   31.790426]  ____sys_sendmsg+0x620/0x770
> [   31.793458]  ___sys_sendmsg+0xfd/0x170
> [   31.802216]  __sys_sendmsg+0xdf/0x1a0
> [   31.806195]  do_syscall_64+0xa0/0x540
> [   31.806885]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> Fixes: 8e94c3bc922e ("drop_monitor: Allow user to start monitoring hardware drops")
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> ---
>  net/core/drop_monitor.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
> index ea46fc6aa883..31700e0c3928 100644
> --- a/net/core/drop_monitor.c
> +++ b/net/core/drop_monitor.c
> @@ -1000,8 +1000,10 @@ static void net_dm_hw_monitor_stop(struct netlink_ext_ack *extack)
>  {
>  	int cpu;
>  
> -	if (!monitor_hw)
> +	if (!monitor_hw) {
>  		NL_SET_ERR_MSG_MOD(extack, "Hardware monitoring already disabled");
> +		return;
> +	}
>  
>  	monitor_hw = false;
>  
> -- 
> 2.24.1
> 
> 
Dave already applied it, but fwiw
Acked-by: Neil Horman <nhorman@tuxdriver.com>
