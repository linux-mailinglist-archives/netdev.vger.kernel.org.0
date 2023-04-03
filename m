Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4CAB6D3CB1
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 07:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231390AbjDCFPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 01:15:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbjDCFPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 01:15:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE69C5FDB;
        Sun,  2 Apr 2023 22:15:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7377D61490;
        Mon,  3 Apr 2023 05:15:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DDEAC433D2;
        Mon,  3 Apr 2023 05:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680498902;
        bh=Ixr/FFBnESFYocqUR2S5brutidXiL5FXC0yTKcWtPxk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GazujrsRaycMDAoP33HEUQ0JfQ7EMg0bNtPSIQJZat3LWer2Eu2uIckZ9nNpBnNYp
         OXXbsQuyymB7jgZrClRzUWhjM6HPjHsbJUswwCj6jxaM+Z1psmxYl4PwehOaikiilM
         xvDmEbw+J/6MWCb/eyyQ1GnTSl7JKfs75iuFk9TPV1K43UPjBAtNGIFiUhQw1KUncq
         0HU0wq035hQx2DLpOkdINRQCmU6FWpQYMZdMonql8+0ksJnX+JqUc7qP7XzHF4FdNF
         l/EKnY05EvqGepme2Og3KXyaVFY0JbTdCMceCHRxtXisTmGuBpQuhjBNRazZJh+zuE
         D/OaXOKyIbxdw==
Date:   Mon, 3 Apr 2023 10:44:56 +0530
From:   Manivannan Sadhasivam <mani@kernel.org>
To:     Simon Horman <horms@kernel.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH RFC] net: qrtr: correct types of trace event parameters
Message-ID: <20230403051436.GA4627@thinkpad>
References: <20230402-qrtr-trace-types-v1-1-da062d368e74@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230402-qrtr-trace-types-v1-1-da062d368e74@kernel.org>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 02, 2023 at 01:15:33PM +0200, Simon Horman wrote:
> The arguments passed to the trace events are of type unsigned int,
> however the signature of the events used __le32 parameters.
> 
> I may be missing the point here, but sparse flagged this and it
> does seem incorrect to me.
> 
>   net/qrtr/ns.c: note: in included file (through include/trace/trace_events.h, include/trace/define_trace.h, include/trace/events/qrtr.h):
>   ./include/trace/events/qrtr.h:11:1: warning: cast to restricted __le32
>   ./include/trace/events/qrtr.h:11:1: warning: restricted __le32 degrades to integer
>   ./include/trace/events/qrtr.h:11:1: warning: restricted __le32 degrades to integer
>   ... (a lot more similar warnings)
>   net/qrtr/ns.c:115:47:    expected restricted __le32 [usertype] service
>   net/qrtr/ns.c:115:47:    got unsigned int service
>   net/qrtr/ns.c:115:61: warning: incorrect type in argument 2 (different base types)
>   ... (a lot more similar warnings)
> 

You are right. The actual arguments (service, instance, node, port) transferred/
received over QRTR are in le32 as per the protocol. But in the NS driver, the
arguments passed to the trace events are in the native endian (i.e) before
getting typecased to le32 for transmission.

And my intention was to trace the arguments in native endian format only. So
this patch indeed fixes the issue.

> Signed-off-by: Simon Horman <horms@kernel.org>

Please add the fixes tag once you remove RFC,

Fixes: dfddb54043f0 ("net: qrtr: Add tracepoint support")

Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>

- Mani

> ---
>  include/trace/events/qrtr.h | 33 ++++++++++++++++++---------------
>  1 file changed, 18 insertions(+), 15 deletions(-)
> 
> diff --git a/include/trace/events/qrtr.h b/include/trace/events/qrtr.h
> index b1de14c3bb93..441132c67133 100644
> --- a/include/trace/events/qrtr.h
> +++ b/include/trace/events/qrtr.h
> @@ -10,15 +10,16 @@
>  
>  TRACE_EVENT(qrtr_ns_service_announce_new,
>  
> -	TP_PROTO(__le32 service, __le32 instance, __le32 node, __le32 port),
> +	TP_PROTO(unsigned int service, unsigned int instance,
> +		 unsigned int node, unsigned int port),
>  
>  	TP_ARGS(service, instance, node, port),
>  
>  	TP_STRUCT__entry(
> -		__field(__le32, service)
> -		__field(__le32, instance)
> -		__field(__le32, node)
> -		__field(__le32, port)
> +		__field(unsigned int, service)
> +		__field(unsigned int, instance)
> +		__field(unsigned int, node)
> +		__field(unsigned int, port)
>  	),
>  
>  	TP_fast_assign(
> @@ -36,15 +37,16 @@ TRACE_EVENT(qrtr_ns_service_announce_new,
>  
>  TRACE_EVENT(qrtr_ns_service_announce_del,
>  
> -	TP_PROTO(__le32 service, __le32 instance, __le32 node, __le32 port),
> +	TP_PROTO(unsigned int service, unsigned int instance,
> +		 unsigned int node, unsigned int port),
>  
>  	TP_ARGS(service, instance, node, port),
>  
>  	TP_STRUCT__entry(
> -		__field(__le32, service)
> -		__field(__le32, instance)
> -		__field(__le32, node)
> -		__field(__le32, port)
> +		__field(unsigned int, service)
> +		__field(unsigned int, instance)
> +		__field(unsigned int, node)
> +		__field(unsigned int, port)
>  	),
>  
>  	TP_fast_assign(
> @@ -62,15 +64,16 @@ TRACE_EVENT(qrtr_ns_service_announce_del,
>  
>  TRACE_EVENT(qrtr_ns_server_add,
>  
> -	TP_PROTO(__le32 service, __le32 instance, __le32 node, __le32 port),
> +	TP_PROTO(unsigned int service, unsigned int instance,
> +		 unsigned int node, unsigned int port),
>  
>  	TP_ARGS(service, instance, node, port),
>  
>  	TP_STRUCT__entry(
> -		__field(__le32, service)
> -		__field(__le32, instance)
> -		__field(__le32, node)
> -		__field(__le32, port)
> +		__field(unsigned int, service)
> +		__field(unsigned int, instance)
> +		__field(unsigned int, node)
> +		__field(unsigned int, port)
>  	),
>  
>  	TP_fast_assign(
> 

-- 
மணிவண்ணன் சதாசிவம்
