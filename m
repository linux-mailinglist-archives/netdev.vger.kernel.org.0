Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA2859CA89
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 23:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237381AbiHVVKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 17:10:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237048AbiHVVKv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 17:10:51 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6A286FFD;
        Mon, 22 Aug 2022 14:10:50 -0700 (PDT)
Date:   Mon, 22 Aug 2022 23:10:45 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Paul Blakey <paulb@nvidia.com>
Cc:     Oz Shlomo <ozsh@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net 1/1] netfilter: flowtable: Fix use after free after
 freeing flow table
Message-ID: <YwPw1ZqiiuGdCGeB@salvia>
References: <1660807674-28447-1-git-send-email-paulb@nvidia.com>
 <Yv7FauVMX2Smkiqb@salvia>
 <11b87f33-98fb-e49a-5f63-491d4f27e908@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <11b87f33-98fb-e49a-5f63-491d4f27e908@nvidia.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Paul,

On Sun, Aug 21, 2022 at 12:23:39PM +0300, Paul Blakey wrote:
> Hi!
> 
> The only functional difference here (for HW table) is your patches call
> flush just for the del workqueue instead of del/stats/add, right?
> 
> Because in the end you do:
> cancel_delayed_work_sync(&flow_table->gc_work);
> nf_flow_table_offload_flush(flow_table);
> nf_flow_table_iterate(flow_table, nf_flow_table_do_cleanup, NULL);
> nf_flow_table_gc_run(flow_table);
> nf_flow_table_offload_flush_cleanup(flow_table);
> 
> 
> resulting in the following sequence (after expending flush_cleanup()):
> 
> cancel_delayed_work_sync(&flow_table->gc_work);
> nf_flow_table_offload_flush(flow_table);
> nf_flow_table_iterate(flow_table, nf_flow_table_do_cleanup, NULL);
> nf_flow_table_gc_run(flow_table);
> flush_workqueue(nf_flow_offload_del_wq);
> nf_flow_table_gc_run(flowtable);
> 
> 
> Where as my (and Volodymyr's) patch does:
> 
> cancel_delayed_work_sync(&flow_table->gc_work);
> nf_flow_table_offload_flush(flow_table);
> nf_flow_table_iterate(flow_table, nf_flow_table_do_cleanup, NULL);
> nf_flow_table_iterate(flow_table, nf_flow_offload_gc_step, NULL);
> nf_flow_table_offload_flush(flow_table);
> nf_flow_table_iterate(flow_table, nf_flow_offload_gc_step, NULL);
> 
> 
> so almost identical, I don't see "extra reiterative calls to flush" here,
> but I'm fine with just your patch as it's more efficient, can we take yours
> to both gits?

Yes, I'll submit them. I'll re-use your patch description.

Maybe I get a Tested-by: tag from you?

Thanks!
