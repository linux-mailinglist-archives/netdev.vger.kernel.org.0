Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06D616E2659
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 17:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbjDNPAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 11:00:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbjDNPAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 11:00:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B1BCBB8C
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 07:58:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681484331;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=k9tZKbJ5qs0aTJOWbxa+ntg7JuywwVnLOpTSJzXLREE=;
        b=QtBnI/Q4f4HWyqfeF2tMIig3m2aqPLIGSoMPH4pg3Vq/9WQylmdTlMLACiQCxtlMr1oYrG
        fkdenaIAcQwMgB4g4Vw8zFcjKw8epKl7jDs922Y13RzWwVm7t1eiMUXQlkZ9EhAccO9pRn
        LWfbTmAOVGxJrtkNy/8iE6lXz/eomxM=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-8-MzqXOYCMOW6Gg1dzm5oWCA-1; Fri, 14 Apr 2023 10:58:50 -0400
X-MC-Unique: MzqXOYCMOW6Gg1dzm5oWCA-1
Received: by mail-oi1-f200.google.com with SMTP id o5-20020acaf005000000b0038c581b6380so74221oih.15
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 07:58:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681484328; x=1684076328;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k9tZKbJ5qs0aTJOWbxa+ntg7JuywwVnLOpTSJzXLREE=;
        b=HtQWFpLL/BD59g9OxNCwfCaZrGVkVLzn8SSQi41Nk+Ku995kpMBT4tIiCUGb9BP5T8
         +1xd9sQJj3GAtfPzgp1fiCe9pGhb4P+NuLZXr0HQWPkCXRPlzBn2bm6BzZkyCksshRj7
         whDowvG2gGGHawVI00lW/p6Sv72Dp4d6fTIWktZciMwXBbGPQ9pDgU9aZ+3xlBRTxKzJ
         MNWv54TKf29X7c/poOnwjk/o7K+fk9BrU0csPktvxkJrTv367rWBhLvWfVF7yXOTgZmC
         om66EgNHJdOBitGKrGXJS05lf4Ya1JdEOAJWPqkZ0rUCKJHhj8Ae0abbysF/bRjipXzL
         U84A==
X-Gm-Message-State: AAQBX9fvTLejTLLY1zi6LwMRSHpMRnnRqN1NRiqgE6RqMMjVzWPy8PBm
        JTm/RlW5mgruJ4lL314lMLEjeV3tzufl0L/Cbq0Kb4W71ws0pLIiNAA//PVWz3P568/vg0XMPSu
        3q9UJ1axW1uajRE6N
X-Received: by 2002:a54:4594:0:b0:389:7d66:131a with SMTP id z20-20020a544594000000b003897d66131amr2571656oib.0.1681484328418;
        Fri, 14 Apr 2023 07:58:48 -0700 (PDT)
X-Google-Smtp-Source: AKy350bkRH9KaOHjyXtwFRXXzVwyZiRQ/axbyA+HWVFGo3S3BIN+ZZccIIJ8MK7vkdCqMcmg6iiLag==
X-Received: by 2002:a54:4594:0:b0:389:7d66:131a with SMTP id z20-20020a544594000000b003897d66131amr2571637oib.0.1681484328154;
        Fri, 14 Apr 2023 07:58:48 -0700 (PDT)
Received: from halaney-x13s (104-53-165-62.lightspeed.stlsmo.sbcglobal.net. [104.53.165.62])
        by smtp.gmail.com with ESMTPSA id n84-20020acaef57000000b0038bb2f60064sm1737277oih.30.2023.04.14.07.58.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Apr 2023 07:58:47 -0700 (PDT)
Date:   Fri, 14 Apr 2023 09:58:44 -0500
From:   Andrew Halaney <ahalaney@redhat.com>
To:     Stephen Boyd <sboyd@kernel.org>
Cc:     linux-kernel@vger.kernel.org, agross@kernel.org,
        andersson@kernel.org, konrad.dybcio@linaro.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, mturquette@baylibre.com,
        richardcochran@gmail.com, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-clk@vger.kernel.org,
        netdev@vger.kernel.org, bmasney@redhat.com, echanude@redhat.com,
        ncai@quicinc.com, jsuraj@qti.qualcomm.com, hisunil@quicinc.com
Subject: Re: [PATCH v5 3/3] arm64: dts: qcom: sa8540p-ride: Add ethernet nodes
Message-ID: <20230414145844.wyg6pt623pzqwh5l@halaney-x13s>
References: <20230413191541.1073027-1-ahalaney@redhat.com>
 <20230413191541.1073027-4-ahalaney@redhat.com>
 <a295939f0058373d1caf956749820c0d.sboyd@kernel.org>
 <20230413210127.s5dkek6adp5ndern@halaney-x13s>
 <7b2b2eefb4b7b6ef8ac2a3176286a97b.sboyd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b2b2eefb4b7b6ef8ac2a3176286a97b.sboyd@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 13, 2023 at 03:05:26PM -0700, Stephen Boyd wrote:
> Quoting Andrew Halaney (2023-04-13 14:01:27)
> > On Thu, Apr 13, 2023 at 01:47:19PM -0700, Stephen Boyd wrote:
> > > Quoting Andrew Halaney (2023-04-13 12:15:41)
> > > >  arch/arm64/boot/dts/qcom/sa8540p-ride.dts | 179 ++++++++++++++++++++++
> > > >  1 file changed, 179 insertions(+)
> > > > 
> > > > diff --git a/arch/arm64/boot/dts/qcom/sa8540p-ride.dts b/arch/arm64/boot/dts/qcom/sa8540p-ride.dts
> > > > index 40db5aa0803c..650cd54f418e 100644
> > > > --- a/arch/arm64/boot/dts/qcom/sa8540p-ride.dts
> > > > +++ b/arch/arm64/boot/dts/qcom/sa8540p-ride.dts
> > > > @@ -28,6 +28,65 @@ aliases {
> > > >         chosen {
> > > >                 stdout-path = "serial0:115200n8";
> > > >         };
> > > > +
> > > > +       mtl_rx_setup: rx-queues-config {
> > > 
> > > Is there a reason why this isn't a child of an ethernet node?
> > > 
> > > 
> > 
> > I debated if it was more appropriate to:
> > 
> >     1. make a duplicate in each ethernet node (ethernet0/1)
> >     2. Put it in one and reference from both
> >     3. have it floating around independent like this, similar to what is
> >        done in sa8155p-adp.dts[0]
> > 
> > I chose 3 as it seemed cleanest, but if there's a good argument for a
> > different approach I'm all ears!
> 
> I wonder if it allows the binding checker to catch bad properties by
> having it under the ethernet node? That's the only thing I can think of
> that may be improved, but I'll let binding reviewers comment here.
> 

Thanks, I was curious so I played around to answer the question via
testing, and you're right... rx-queues-config/tx-queues-config aren't
evaluated unless they sit under the node with the compatible (i.e. it
doesn't just follow the phandle and evaluate). That makes sense to me I
suppose.

So, I guess, would maintainers prefer to see option (1) or (2) above? I
want that thing evaluated.

Option 1., above, has duplicated configuration, but is probably a more accurate
representation of the hardware description.

Option 2., above, doesn't duplicate rx-queues-config/tx-queues-config,
but is a weirder representation of hardware description, and only
complains once (which is fine since it's shared) when the binding checker
runs (i.e. only the etherent parent containing rx-queues-config yells).

In the below example you can see what I mean by the "only complains
once" comment as well as illustration that the patchset as is doesn't
allow rx-queues-config/tx-queues-config to be validated by dt-binding
checks:

(dtschema) ahalaney@halaney-x13s ~/git/redhat/stmmac (git)-[stmmac] % # Purposely introduce a dt-binding error on top of the current patchset                                                                                          :(
(dtschema) ahalaney@halaney-x13s ~/git/redhat/stmmac (git)-[stmmac] % git diff                                                                                                                                                         :(
diff --git a/arch/arm64/boot/dts/qcom/sa8540p-ride.dts b/arch/arm64/boot/dts/qcom/sa8540p-ride.dts
index 650cd54f418e..ecb0000db4e2 100644
--- a/arch/arm64/boot/dts/qcom/sa8540p-ride.dts
+++ b/arch/arm64/boot/dts/qcom/sa8540p-ride.dts
@@ -54,7 +54,7 @@ queue2 {
 
                queue3 {
                        snps,avb-algorithm;
-                       snps,map-to-dma-channel = <0x3>;
+                       snps,map-to-dma-channel = "not-correct";
                        snps,priority = <0xc>;
                };
        };
(dtschema) ahalaney@halaney-x13s ~/git/redhat/stmmac (git)-[stmmac] % make CHECK_DTBS=y DT_SCHEMA_FILES=/net/qcom,ethqos.yaml qcom/sa8540p-ride.dtb
  DTC_CHK arch/arm64/boot/dts/qcom/sa8540p-ride.dtb
(dtschema) ahalaney@halaney-x13s ~/git/redhat/stmmac (git)-[stmmac] % # That should have failed
(dtschema) ahalaney@halaney-x13s ~/git/redhat/stmmac (git)-[stmmac] % # Move the whole node under ethernet0, have ethernet1 reference via phandle only still
(dtschema) ahalaney@halaney-x13s ~/git/redhat/stmmac (git)-[stmmac] % git diff | cat
diff --git a/arch/arm64/boot/dts/qcom/sa8540p-ride.dts b/arch/arm64/boot/dts/qcom/sa8540p-ride.dts
index 650cd54f418e..451246936731 100644
--- a/arch/arm64/boot/dts/qcom/sa8540p-ride.dts
+++ b/arch/arm64/boot/dts/qcom/sa8540p-ride.dts
@@ -29,35 +29,6 @@ chosen {
 		stdout-path = "serial0:115200n8";
 	};
 
-	mtl_rx_setup: rx-queues-config {
-		snps,rx-queues-to-use = <1>;
-		snps,rx-sched-sp;
-
-		queue0 {
-			snps,dcb-algorithm;
-			snps,map-to-dma-channel = <0x0>;
-			snps,route-up;
-			snps,priority = <0x1>;
-		};
-
-		queue1 {
-			snps,dcb-algorithm;
-			snps,map-to-dma-channel = <0x1>;
-			snps,route-ptp;
-		};
-
-		queue2 {
-			snps,avb-algorithm;
-			snps,map-to-dma-channel = <0x2>;
-			snps,route-avcp;
-		};
-
-		queue3 {
-			snps,avb-algorithm;
-			snps,map-to-dma-channel = <0x3>;
-			snps,priority = <0xc>;
-		};
-	};
 
 	mtl_tx_setup: tx-queues-config {
 		snps,tx-queues-to-use = <1>;
@@ -223,6 +194,36 @@ &ethernet0 {
 
 	status = "okay";
 
+	mtl_rx_setup: rx-queues-config {
+		snps,rx-queues-to-use = <1>;
+		snps,rx-sched-sp;
+
+		queue0 {
+			snps,dcb-algorithm;
+			snps,map-to-dma-channel = <0x0>;
+			snps,route-up;
+			snps,priority = <0x1>;
+		};
+
+		queue1 {
+			snps,dcb-algorithm;
+			snps,map-to-dma-channel = <0x1>;
+			snps,route-ptp;
+		};
+
+		queue2 {
+			snps,avb-algorithm;
+			snps,map-to-dma-channel = <0x2>;
+			snps,route-avcp;
+		};
+
+		queue3 {
+			snps,avb-algorithm;
+			snps,map-to-dma-channel = "not-correct";
+			snps,priority = <0xc>;
+		};
+	};
+
 	mdio {
 		compatible = "snps,dwmac-mdio";
 		#address-cells = <1>;
(dtschema) ahalaney@halaney-x13s ~/git/redhat/stmmac (git)-[stmmac] % make CHECK_DTBS=y DT_SCHEMA_FILES=/net/qcom,ethqos.yaml qcom/sa8540p-ride.dtb
  DTC_CHK arch/arm64/boot/dts/qcom/sa8540p-ride.dtb
/home/ahalaney/git/redhat/stmmac/arch/arm64/boot/dts/qcom/sa8540p-ride.dtb: ethernet@20000: rx-queues-config:queue3:snps,map-to-dma-channel:0: [1852797997, 1668248178, 1701016576] is too long
	From schema: /home/ahalaney/git/redhat/stmmac/Documentation/devicetree/bindings/net/qcom,ethqos.yaml
/home/ahalaney/git/redhat/stmmac/arch/arm64/boot/dts/qcom/sa8540p-ride.dtb: ethernet@20000: Unevaluated properties are not allowed ('max-speed', 'mdio', 'phy-handle', 'phy-mode', 'power-domains', 'rx-fifo-depth', 'rx-queues-config', 'snps,mtl-rx-config', 'snps,mtl-tx-config', 'snps,pbl', 'snps,tso', 'tx-fifo-depth' were unexpected)
	From schema: /home/ahalaney/git/redhat/stmmac/Documentation/devicetree/bindings/net/qcom,ethqos.yaml
(dtschema) ahalaney@halaney-x13s ~/git/redhat/stmmac (git)-[stmmac] % # That warned as expected, since snps,dwmac.yaml failed on rx-queues-config it warns, \
									and since part of the schema failed its not inherited (hence the Unevaluated properties warning following) \
									also note how only ethernet0 (@20000) is evaluating rx-queues-config since that's where the rx-queues-config node lives
(dtschema) ahalaney@halaney-x13s ~/git/redhat/stmmac (git)-[stmmac] %

Thanks for the review!
 - Andrew

