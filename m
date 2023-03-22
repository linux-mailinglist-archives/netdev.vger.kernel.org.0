Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3986C4232
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 06:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbjCVFeo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 01:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbjCVFen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 01:34:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD1594D42F
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 22:34:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F9B761F3D
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 05:34:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84723C433EF;
        Wed, 22 Mar 2023 05:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679463281;
        bh=cCVkUi16R+sDPG6GzvfJG/Or421sUHoRTK1VCMNlS1s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=P9nOzrxLTxIycguQw+lx/qn+cm6A94a5b3xP68JHXvKWFnTaVBM6vYTsmjoDCYo5c
         YH7UWaTy9N5uBMAIh9hDDD3PmsHLQ8IHQ7H48X8sPoTZNTUMKfIXfV47gy6CwHOQNH
         MEPHvP1G+Bl5LPxRE9lWmAxd7NSSoSD/oD7csiD1TDUTIWNbirrBlU2HIBXKPhFQXo
         6Jeo333zYJfhdMnUGaLWiRpxAEGQs07rjCHHC6Eh2ncFbhyX5SegRbLVZOoLASVKw9
         1vszjmY7EjIoccQw1LLtJkDIrER5O2WsuR7Kt/FFyk6ulOe5F0Zcyhw2Ir4n81qmbL
         xTFBoF5ujGDxQ==
Date:   Tue, 21 Mar 2023 22:34:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Donald Hunter <donald.hunter@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, donald.hunter@redhat.com
Subject: Re: [PATCH net-next v2 5/6] tools: ynl: Add fixed-header support to
 ynl
Message-ID: <20230321223440.2bc23eba@kernel.org>
In-Reply-To: <20230319193803.97453-6-donald.hunter@gmail.com>
References: <20230319193803.97453-1-donald.hunter@gmail.com>
        <20230319193803.97453-6-donald.hunter@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 19 Mar 2023 19:38:02 +0000 Donald Hunter wrote:
> -    def __init__(self, family, yaml, req_value, rsp_value):
> +    def __init__(self, family, yaml, req_value, rsp_value, default_fixed_header):
>          super().__init__(family, yaml)
>  
>          self.value = req_value if req_value == rsp_value else None
> @@ -278,6 +279,7 @@ class SpecOperation(SpecElement):
>          self.is_call = 'do' in yaml or 'dump' in yaml
>          self.is_async = 'notify' in yaml or 'event' in yaml
>          self.is_resv = not self.is_async and not self.is_call
> +        self.fixed_header = self.yaml.get('fixed-header', default_fixed_header)
>  
>          # Added by resolve:
>          self.attr_set = None
> @@ -384,24 +386,26 @@ class SpecFamily(SpecElement):
>      def new_struct(self, elem):
>          return SpecStruct(self, elem)
>  
> -    def new_operation(self, elem, req_val, rsp_val):
> -        return SpecOperation(self, elem, req_val, rsp_val)
> +    def new_operation(self, elem, req_val, rsp_val, default_fixed_header):
> +        return SpecOperation(self, elem, req_val, rsp_val, default_fixed_header)
>  
>      def add_unresolved(self, elem):
>          self._resolution_list.append(elem)
>  
>      def _dictify_ops_unified(self):
> +        default_fixed_header = self.yaml['operations'].get('fixed-header')
>          val = 1
>          for elem in self.yaml['operations']['list']:
>              if 'value' in elem:
>                  val = elem['value']
>  
> -            op = self.new_operation(elem, val, val)
> +            op = self.new_operation(elem, val, val, default_fixed_header)
>              val += 1
>  
>              self.msgs[op.name] = op
>  
>      def _dictify_ops_directional(self):
> +        default_fixed_header = self.yaml['operations'].get('fixed-header')
>          req_val = rsp_val = 1
>          for elem in self.yaml['operations']['list']:
>              if 'notify' in elem:
> @@ -426,7 +430,7 @@ class SpecFamily(SpecElement):
>              else:
>                  raise Exception("Can't parse directional ops")
>  
> -            op = self.new_operation(elem, req_val, rsp_val)
> +            op = self.new_operation(elem, req_val, rsp_val, default_fixed_header)

Can we record the "family-default" fixed header in the family and read
from there rather than passing the arg around?

Also - doc - to be clear - by documentation I mean in the right places
under Documentation/user-api/netlink/
